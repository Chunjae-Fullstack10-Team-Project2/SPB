package net.spb.spb.util.formatter;

import org.springframework.format.Formatter;

import java.text.ParseException;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class YearMonthFormatter implements Formatter<YearMonth> {
    @Override
    public YearMonth parse(String text, Locale locale) throws ParseException {
        return YearMonth.parse(text, DateTimeFormatter.ofPattern("yyyy-MM"));
    }

    @Override
    public String print(YearMonth object, Locale locale) {
        return DateTimeFormatter.ofPattern("yyyy-MM").format(object);
    }
}
