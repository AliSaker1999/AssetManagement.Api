using System.Data;
using Dapper;

namespace AssetManagement.Api.Infrastructure;

public sealed class DateOnlyHandler : SqlMapper.TypeHandler<DateOnly>
{
    public override DateOnly Parse(object value)
    {
        return value switch
        {
            DateTime dateTime => DateOnly.FromDateTime(dateTime),
            string text => DateOnly.Parse(text),
            _ => DateOnly.Parse(value.ToString() ?? string.Empty)
        };
    }

    public override void SetValue(IDbDataParameter parameter, DateOnly value)
    {
        parameter.Value = value.ToDateTime(TimeOnly.MinValue);
        parameter.DbType = DbType.Date;
    }
}

public sealed class NullableDateOnlyHandler : SqlMapper.TypeHandler<DateOnly?>
{
    public override DateOnly? Parse(object value)
    {
        if (value == null || value is DBNull)
        {
            return null;
        }

        return value switch
        {
            DateTime dateTime => DateOnly.FromDateTime(dateTime),
            string text => DateOnly.Parse(text),
            _ => DateOnly.Parse(value.ToString() ?? string.Empty)
        };
    }

    public override void SetValue(IDbDataParameter parameter, DateOnly? value)
    {
        if (value.HasValue)
        {
            parameter.Value = value.Value.ToDateTime(TimeOnly.MinValue);
            parameter.DbType = DbType.Date;
        }
        else
        {
            parameter.Value = DBNull.Value;
        }
    }
}
