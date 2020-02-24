module Ovillo
{
    export class SegmentedComponentStorage<Component> implements ComponentStorage<Component>
    {
        private readonly _storageSelector: Converter<Component, ComponentStorage<Component>>;
        private readonly _storageIndex: Map<EntityId, ComponentStorage<Component>>;

        constructor(storageSelector: Converter<Component, ComponentStorage<Component>>)
        {
            this._storageSelector = storageSelector;
            this._storageIndex = new Map<EntityId, ComponentStorage<Component>>();
        }

        isset(entityId: EntityId): boolean
        {
            return this._storageIndex.has(entityId);
        }
        
        get(entityId: EntityId): Option<Component>
        {
            let sourceStorage = this._storageIndex.get(entityId);
            if (sourceStorage === undefined)
            {
                return None<Component>();
            }

            return sourceStorage.get(entityId);
        }

        set(entityId: EntityId, value: Component): void
        {
            let sourceStorage = this._storageIndex.get(entityId);
            let targetStorage = this._storageSelector(value);
            if (sourceStorage !== targetStorage && sourceStorage !== undefined)
            {
                sourceStorage.remove(entityId);
                this._storageIndex.set(entityId, targetStorage);
            }

            targetStorage.set(entityId, value);
        }

        update(entityId: EntityId, valueFactory: Converter<Option<Component>, Option<Component>>): void
        {
            let sourceStorage = this._storageIndex.get(entityId);
            let found: Option<Component> = 
                sourceStorage !== undefined
                ? sourceStorage.get(entityId)
                : None<Component>();
            let value = valueFactory(found);
            if (value.isSome)
            {
                let targetStorage = this._storageSelector(value.value);
                if (sourceStorage !== targetStorage && sourceStorage !== undefined)
                {
                    sourceStorage.remove(entityId);
                    this._storageIndex.set(entityId, targetStorage);
                }

                targetStorage.set(entityId, value.value);
            }
            else
            {
                if (sourceStorage !== undefined)
                {
                    sourceStorage.remove(entityId);
                    this._storageIndex.delete(entityId);
                }
            }
        }

        exchange(entityId: EntityId, value: Component): Option<Component>
        {
            let sourceStorage = this._storageIndex.get(entityId);
            let found: Option<Component> = 
                sourceStorage !== undefined
                ? sourceStorage.get(entityId)
                : None<Component>();
            let targetStorage = this._storageSelector(value);
            if (sourceStorage !== targetStorage && sourceStorage !== undefined)
            {
                sourceStorage.remove(entityId);
                this._storageIndex.set(entityId, targetStorage);
            }

            targetStorage.set(entityId, value);
            return found;
        }

        add(entityId: EntityId, value: Component): boolean
        {
            let sourceStorage = this._storageIndex.get(entityId);
            if (sourceStorage !== undefined)
            {
                return false;
            }

            let targetStorage = this._storageSelector(value);
            targetStorage.set(entityId, value);
            this._storageIndex.set(entityId, targetStorage);
            return true;
        }

        getOrAdd(entityId: EntityId, valueFactory: Factory<Component>): Component
        {
            let sourceStorage = this._storageIndex.get(entityId);
            if (sourceStorage !== undefined)
            {
                let found = sourceStorage.get(entityId);
                if (found.isSome)
                {
                    return found.value;
                }
                else
                {
                    throw "";
                }
            }

            let value = valueFactory();
            let targetStorage = this._storageSelector(value);
            targetStorage.set(entityId, value);
            this._storageIndex.set(entityId, targetStorage);
            return value;
        }

        remove(entityId: EntityId): boolean
        {
            let sourceStorage = this._storageIndex.get(entityId);
            if (sourceStorage === undefined)
            {
                return false;
            }

            sourceStorage.remove(entityId);
            this._storageIndex.delete(entityId);
            return true;
        }

        removeWhere(entityId: EntityId, predicate: Predicate<Component>): boolean
        {
            let sourceStorage = this._storageIndex.get(entityId);
            if (sourceStorage === undefined)
            {
                return false;
            }

            if (sourceStorage.removeWhere(entityId, predicate))
            {
                this._storageIndex.delete(entityId);
                return true;
            }

            return false;
        }

        take(entityId: EntityId): Option<Component>
        {
            let sourceStorage = this._storageIndex.get(entityId);
            if (sourceStorage === undefined)
            {
                return None<Component>();
            }

            let result = sourceStorage.take(entityId);
            this._storageIndex.delete(entityId);
            return result;
        }
    }
}