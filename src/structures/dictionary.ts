module Ovillo.Structures
{
    export interface Dictionary<Key, Value>
    {
        add(key: Key, value: Value): boolean;

        clear(): void;

        contains(key: Key): boolean;

        exchange(key: Key, value: Value): Option<Value>;

        get(key: Key): Option<Value>;

        getOrAdd(key: Key, valueFactory: Factory<Value>): Value;

        remove(key: Key): boolean;

        removeWhere(key: Key, predicate: Predicate<Value>): boolean;

        set(key: Key, value: Value): void;

        readonly size: number;

        take(key: Key): Option<Value>;

        update(key: Key, valueFactory: Converter<Option<Value>, Option<Value>>): void;
    }
}