module Ovillo
{
    export type Option<T> = {isSome: true, value: T}
                          | {isSome: false};

    export function None<T>(): Option<T>
    {
        return {isSome: false};
    }

    export function Some<T>(input: T extends null | void ? never : T): Option<T>
    {
        return {isSome: true, value: input};
    }

    export function IsSome<T>(input: T | null | void): input is T
    {
        return input !== null && typeof input !== "undefined";
    }

    export function Option<T>(input?: T | null | void): Option<T>
    {
        if (IsSome<T>(input))
        {
            return {isSome: true, value: input};
        }

        return {isSome: false};
    }

    export function Bind<TInput, TOutput>(option: Option<TInput>, converter: Converter<TInput, TOutput>): Option<TOutput>
    {
        if (option.isSome)
        {
            return Option<TOutput>(converter(option.value));
        }
        return None<TOutput>();
    }
}