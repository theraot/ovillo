module Engine
{
    export type ComponentChanged<Component> = {readonly change: "add", readonly entityId: EntityId, readonly newValue: Component}
                                            | {readonly change: "remove", readonly entityId: EntityId, readonly oldValue: Component}
                                            | {readonly change: "change", readonly entityId: EntityId, readonly oldValue: Component, newValue: Component}
}