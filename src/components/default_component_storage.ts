/// <reference path="../structures/default_dictionary.ts" />

module Ovillo
{
    export class DefaultComponentStorage<Component> extends Structures.DefaultDictionary<EntityId, Component>
                                                    implements ComponentStorage<Component>
    {
        // Empty
    }
}