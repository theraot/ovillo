module Engine
{
    export type Action<T> = (value: T) => void;
}