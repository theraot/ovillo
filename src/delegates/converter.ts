module Engine
{
    export type Converter<TInput, TOutput> = (input: TInput) => TOutput;
}