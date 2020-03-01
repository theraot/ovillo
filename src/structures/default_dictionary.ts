module Ovillo
{
    export class DefaultDictionary<Key, Value> implements Dictionary<Key, Value>
    {
        private readonly _storage: Map<Key, Value>;

        public constructor()
        {
            this._storage = new Map<Key, Value>();
        }

        public add(Key: Key, value: Value): boolean
        {
            if (this._storage.has(Key))
            {
                return false;
            }

            this._storage.set(Key, value);
            return true;
        }

        public clear(): void
        {
            this._storage.clear();
        }

        public contains(Key: Key): boolean
        {
            return this._storage.has(Key);
        }

        public exchange(Key: Key, value: Value): Option<Value>
        {
            let found = Option<Value>(this._storage.get(Key));
            this._storage.set(Key, value);
            return found;
        }

        public get(Key: Key): Option<Value>
        {
            return Option<Value>(this._storage.get(Key));
        }

        public getOrAdd(Key: Key, valueFactory: Factory<Value>): Value
        {
            let found = this._storage.get(Key);
            if (IsSome<Value>(found))
            {
                return found;
            }

            let value = valueFactory();
            this._storage.set(Key, value);
            return value;
        }

        public remove(Key: Key): boolean
        {
            return this._storage.delete(Key);
        }

        public removeWhere(Key: Key, predicate: Predicate<Value>): boolean
        {
            let found = this._storage.get(Key);
            if (IsSome<Value>(found) && predicate(found))
            {
                this._storage.delete(Key);
                return true;
            }

            return false;
        }

        public set(Key: Key, value: Value): void
        {
            this._storage.set(Key, value);
        }

        public get size(): number
        {
            return this._storage.size;
        }

        public take(Key: Key): Option<Value>
        {
            let found = this._storage.get(Key);
            this._storage.delete(Key);
            return Option<Value>(found);
        }

        public update(Key: Key, valueFactory: Converter<Option<Value>, Option<Value>>): void
        {
            let found = Option<Value>(this._storage.get(Key));
            let value = valueFactory(found);
            if (value.isSome)
            {
                this._storage.set(Key, value.value);
            }
            else
            {
                this._storage.delete(Key);
            }
        }
    }
}