module Engine
{
    export interface EventDispatcher<T>
    {
        raise: Action<T>;
    }

    export class Event<T>
    {
        private readonly _handlers: Set<Action<T>>;

        constructor (dispatcher: EventDispatcher<T>)
        {
            this._handlers = new Set<Action<T>>();
            dispatcher.raise = (value: T) =>
            {
                for (let handler of this._handlers)
                {
                    handler(value);
                }
            };
        }

        public subscribe (handler: Action<T>): Deletable
        {
            this._handlers.add(handler);
            return {Delete: () => {this._handlers.delete(handler);}};
        }
    }
}