module Engine
{
    export class ComponentStorageWrapper<Component> implements ComponentStorage<Component>
    {
        private readonly _wrapped: ComponentStorage<Component>;
        private readonly _dispatcher: EventDispatcher<ComponentChanged<Component>>;
        public readonly componentChanged: Event<ComponentChanged<Component>>;

        private constructor(wrapped: ComponentStorage<Component>)
        {
            this._wrapped = wrapped;
            this._dispatcher = {raise: (_: ComponentChanged<Component>) => {}};
            this.componentChanged = new Event<ComponentChanged<Component>>(this._dispatcher);
        }

        public static Create<Component>(wrapped: ComponentStorageWrapper<Component> | ComponentStorage<Component>)
        {
            return new ComponentStorageWrapper<Component>(wrapped);
        }

        public static CreateDefault<Component>()
        {
            return new ComponentStorageWrapper<Component>(new DefaultComponentStorage<Component>());
        }

        public static CreateDefaultSingleComponent<Component>(entityId: EntityId, value: Component)
        {
            let wrapped = new DefaultComponentStorage<Component>();
            wrapped.set(entityId, value);
            return new ComponentStorageWrapper<Component>(wrapped);
        }

        public isset(entityId: EntityId): boolean
        {
            return this._wrapped.isset(entityId);
        }

        public get(entityId: EntityId): Option<Component>
        {
            return this._wrapped.get(entityId);
        }

        public set(entityId: EntityId, value: Component): void
        {
            this.exchange(entityId, value);
        }

        public update(entityId: EntityId, valueFactory: Converter<Option<Component>, Option<Component>>): void
        {
            let componentChangeHolder: Option<ComponentChanged<Component>> = None<ComponentChanged<Component>>();
            this._wrapped.update(
                entityId,
                (input: Option<Component>): Option<Component> =>
                {
                    let output = valueFactory(input);
                    if (input.isSome)
                    {
                        if (output.isSome)
                        {
                            componentChangeHolder = Some({change: "change", entityId: entityId, oldValue: input.value, newValue: output.value});
                        }
                        else
                        {
                            componentChangeHolder = Some({change: "remove", entityId: entityId, oldValue: input.value});
                        }
                    }
                    else
                    {
                        if (output.isSome)
                        {
                            componentChangeHolder = Some({change: "add", entityId: entityId, newValue: output.value});
                        }
                        else
                        {
                            componentChangeHolder = None<ComponentChanged<Component>>();
                        }
                    }
                    return output;
                }
            );
            if (componentChangeHolder.isSome)
            {
                this._dispatcher.raise(componentChangeHolder.value);
            }
        }

        public exchange(entityId: EntityId, value: Component): Option<Component>
        {
            let found = this._wrapped.exchange(entityId, value);
            if (found.isSome)
            {
                this._dispatcher.raise({change: "change", entityId: entityId, oldValue: found.value, newValue: value});
            }
            else
            {
                this._dispatcher.raise({change: "add", entityId: entityId, newValue: value});
            }
            return found;
        }

        public add(entityId: EntityId, value: Component): boolean
        {
            if (this._wrapped.add(entityId, value))
            {
                this._dispatcher.raise({change: "add", entityId: entityId, newValue: value});
                return true;
            }

            return false;
        }

        public getOrAdd(entityId: EntityId, valueFactory: Factory<Component>): Component
        {
            let componentChangeHolder: Option<ComponentChanged<Component>> = None<ComponentChanged<Component>>();
            let result = this._wrapped.getOrAdd(
                entityId,
                (): Component =>
                {
                    let value = valueFactory();
                    componentChangeHolder = Some({change: "add", entityId: entityId, newValue: value})
                    return value;
                }
            )
            if (componentChangeHolder.isSome)
            {
                this._dispatcher.raise(componentChangeHolder.value);
            }

            return result;
        }

        public remove(entityId: EntityId): boolean
        {
            let found = this._wrapped.take(entityId);
            if (found.isSome)
            {
                this._dispatcher.raise({change: "remove", entityId: entityId, oldValue: found.value});
                return true;
            }

            return false;
        }

        public removeWhere(entityId: EntityId, predicate: Predicate<Component>): boolean
        {
            let componentChangeHolder: Option<ComponentChanged<Component>> = None<ComponentChanged<Component>>();
            this._wrapped.removeWhere(
                entityId,
                (value: Component): boolean =>
                {
                    if (predicate(value))
                    {
                        componentChangeHolder = Some({change: "remove", entityId: entityId, oldValue: value});
                        return true;
                    }

                    return false;
                }
            );
            if (componentChangeHolder.isSome)
            {
                this._dispatcher.raise(componentChangeHolder.value);
                return true;
            }

            return false;
        }

        public take(entityId: EntityId): Option<Component>
        {
            let found = this._wrapped.take(entityId);
            if (found.isSome)
            {
                this._dispatcher.raise({change: "remove", entityId: entityId, oldValue: found.value});
                return found;
            }

            return found;
        }
    }
}