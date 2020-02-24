module Ovillo
{
    export class DefaultComponentStorage<Component> implements ComponentStorage<Component>
    {
        private readonly _storage: Map<EntityId, Component>;

        constructor()
        {
            this._storage = new Map<EntityId, Component>();
        }

        isset(entityId: EntityId): boolean
        {
            return this._storage.has(entityId);
        }

        get(entityId: EntityId): Option<Component>
        {
            return Option<Component>(this._storage.get(entityId));
        }

        set(entityId: EntityId, value: Component): void
        {
            this._storage.set(entityId, value);
        }

        update(entityId: EntityId, valueFactory: Converter<Option<Component>, Option<Component>>): void
        {
            let found = Option<Component>(this._storage.get(entityId));
            let value = valueFactory(found);
            if (value.isSome)
            {
                this._storage.set(entityId, value.value);
            }
            else
            {
                this._storage.delete(entityId);
            }
        }

        exchange(entityId: EntityId, value: Component): Option<Component>
        {
            let found = Option<Component>(this._storage.get(entityId));
            this._storage.set(entityId, value);
            return found;
        }

        add(entityId: EntityId, value: Component): boolean
        {
            if (this._storage.has(entityId))
            {
                return false;
            }

            this._storage.set(entityId, value);
            return true;
        }

        getOrAdd(entityId: EntityId, valueFactory: Factory<Component>): Component
        {
            let found = this._storage.get(entityId);
            if (IsSome<Component>(found))
            {
                return found;
            }

            let value = valueFactory();
            this._storage.set(entityId, value);
            return value;
        }

        remove(entityId: EntityId): boolean
        {
            return this._storage.delete(entityId);
        }

        removeWhere(entityId: EntityId, predicate: Predicate<Component>): boolean
        {
            let found = this._storage.get(entityId);
            if (IsSome<Component>(found) && predicate(found))
            {
                this._storage.delete(entityId);
                return true;
            }

            return false;
        }

        take(entityId: EntityId): Option<Component>
        {
            let found = this._storage.get(entityId);
            this._storage.delete(entityId);
            return Option<Component>(found);
        }
    }
}