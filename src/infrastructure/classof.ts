module Ovillo
{
    export type classof<T> = new (...args:any[]) => T;
}