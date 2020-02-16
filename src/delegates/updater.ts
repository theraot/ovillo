module Engine
{
    export type Updater<T> = (value: T) => T;
}