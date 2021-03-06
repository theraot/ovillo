module Ovillo
{
    export class World
    {
        private readonly _worldStorage: Map<string, ComponentStorage<any>>;

        public constructor()
        {
            this._worldStorage = new Map<string, ComponentStorage<any>>();
        }

        public add<Component>(entityId: EntityId, value: Component): boolean
        {
            let componentKindName = classname(value);
            if (componentKindName === null)
            {
                throw "value must be an instance of a class";
            }

            let componentStorage = this._worldStorage.get(componentKindName);
            if (!IsSome<ComponentStorage<any>>(componentStorage))
            {
                componentStorage = this._createSingleComponentStorageHolder(entityId, value);
                this._worldStorage.set(componentKindName, componentStorage);
                return true;
            }

            return componentStorage.add(entityId, value);
        }

        public exchange<Component>(entityId: EntityId, value: Component): Option<Component>
        {
            let componentKindName = classname(value);
            if (componentKindName === null)
            {
                throw "value must be an instance of a class";
            }

            let componentStorage = this._worldStorage.get(componentKindName);
            if (!IsSome<ComponentStorage<any>>(componentStorage))
            {
                componentStorage = this._createSingleComponentStorageHolder(entityId, value);
                this._worldStorage.set(componentKindName, componentStorage);
                return None<Component>();
            }

            return componentStorage.exchange(entityId, value);
        }

        public get<Component>(entityId: EntityId, componentKind: classof<Component>): Option<Component>
        {
            let componentStorage = this._worldStorage.get(componentKind.name)
            if (!IsSome<ComponentStorage<any>>(componentStorage))
            {
                return None<Component>();
            }

            return componentStorage.get(entityId);
        }

        public getOrAdd<Component>(entityId: EntityId, componentKind: classof<Component>, valueFactory: Factory<Component>): Component
        {
            let componentStorage = this._worldStorage.get(componentKind.name);
            if (!IsSome<ComponentStorage<any>>(componentStorage))
            {
                let value = valueFactory();
                componentStorage = this._createSingleComponentStorageHolder(entityId, value);
                this._worldStorage.set(componentKind.name, componentStorage);
                return value;
            }

            return componentStorage.getOrAdd(entityId, valueFactory);
        }

        public has<Component>(entityId: EntityId, componentKind: classof<Component>): boolean
        {
            let componentStorage = this._worldStorage.get(componentKind.name)
            if (!IsSome<ComponentStorage<any>>(componentStorage))
            {
                return false;
            }

            return componentStorage.contains(entityId);
        }

        public register<Component>(componentKind: classof<Component>, componentStorage: ComponentStorage<Component>): boolean
        {
            if (this._worldStorage.has(componentKind.name))
            {
                return false;
            }

            this._worldStorage.set(componentKind.name, this._createStorageHolder(componentStorage));
            return true;
        }

        public remove<Component>(entityId: EntityId, componentKind: classof<Component>): boolean
        {
            let componentStorage = this._worldStorage.get(componentKind.name);
            if (!IsSome<ComponentStorage<any>>(componentStorage))
            {
                return false;
            }

            return componentStorage.remove(entityId);
        }

        public removeWhere<Component>(entityId: EntityId, componentKind: classof<Component>, predicate: Predicate<Component>): boolean
        {
            let componentStorage = this._worldStorage.get(componentKind.name);
            if (!IsSome<ComponentStorage<any>>(componentStorage))
            {
                return false;
            }

            return componentStorage.removeWhere(entityId, predicate);
        }

        public set<Component>(entityId: EntityId, value: Component): void
        {
            let componentKindName = classname(value);
            if (componentKindName === null)
            {
                throw "value must be an instance of a class";
            }

            let componentStorage = this._worldStorage.get(componentKindName);
            if (!IsSome<ComponentStorage<any>>(componentStorage))
            {
                componentStorage = this._createSingleComponentStorageHolder(entityId, value);
                this._worldStorage.set(componentKindName, componentStorage);
                return;
            }

            componentStorage.set(entityId, value);
        }

        public take<Component>(entityId: EntityId, componentKind: classof<Component>): Option<Component>
        {
            let componentStorage = this._worldStorage.get(componentKind.name);
            if (!IsSome<ComponentStorage<any>>(componentStorage))
            {
                return None<Component>();
            }

            return componentStorage.take(entityId);
        }

        public update<Component>(entityId: EntityId, componentKind: classof<Component>, valueFactory: Converter<Option<Component>, Option<Component>>): void
        {
            let componentStorage = this._worldStorage.get(componentKind.name)
            if (!IsSome<ComponentStorage<any>>(componentStorage))
            {
                let value = valueFactory(None<Component>());
                componentStorage = this._createSingleComponentStorageHolder(entityId, value);
                this._worldStorage.set(componentKind.name, componentStorage);
                return;
            }

            return componentStorage.update(entityId, valueFactory);
        }

        private _createStorageHolder<Component>(componentStorage: ComponentStorage<Component>): ComponentStorage<any>
        {
            return componentStorage;
        }

        private _createSingleComponentStorageHolder<Component>(entityId: EntityId, component: Component): ComponentStorage<any>
        {
            let storage = new DefaultComponentStorage<Component>();
            storage.set(entityId, component);
            return this._createStorageHolder(storage);
        }
    }
}