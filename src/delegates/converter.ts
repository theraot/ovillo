module Ovillo
{
    export type Converter<TInput, TOutput> = (input: TInput) => TOutput;
}