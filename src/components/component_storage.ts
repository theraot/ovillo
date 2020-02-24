module Ovillo
{
    export interface ComponentStorage<Component>
    {
        isset(entityId: EntityId): boolean;

        get(entityId: EntityId): Option<Component>;

        set(entityId: EntityId, value: Component): void;

        update(entityId: EntityId, valueFactory: Converter<Option<Component>, Option<Component>>): void;

        exchange(entityId: EntityId, value: Component): Option<Component>;

        add(entityId: EntityId, value: Component): boolean;

        getOrAdd(entityId: EntityId, valueFactory: Factory<Component>): Component;

        remove(entityId: EntityId): boolean;

        removeWhere(entityId: EntityId, predicate: Predicate<Component>): boolean;

        take(entityId: EntityId): Option<Component>;
    }
}