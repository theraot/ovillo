module Engine
{
    export function classname(value: any) : string | null
    {
        if (value.constructor === undefined)
        {
            return null;
        }

        return value.constructor.name;
    }
}