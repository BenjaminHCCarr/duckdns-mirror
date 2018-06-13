package org.duckdns.util;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.TimeZone;

public class FormatHelper {
	
	private static final String SIMPLE_PATTERN = "MM/dd/yy hh:mm:ss aa";
	private static final String SIMPLE_PATTERN_OLD = "MM/dd/yy hh:mm aa";
	private static final String JSON_PATTERN = "yyyy-MM-dd'T'HH:mm:ss'Z'";

	private static long oneSecond = 1000;
	private static long oneMinute = oneSecond * 60;
	private static long oneHour = oneMinute * 60;
	private static long oneDay = oneHour * 24;
	private static long oneWeek = oneDay * 7;
	private static long oneMonth = oneDay * 30;
	private static long oneYear = oneDay * 365;
	
	public static String toJsonDate(Date inputDate) {
		String dateAsString = "";
		SimpleDateFormat outFormat = new SimpleDateFormat(JSON_PATTERN);
		TimeZone tz = TimeZone.getTimeZone("UTC");
		outFormat.setTimeZone(tz);
		try {
			dateAsString = outFormat.format(inputDate);
		} catch (Throwable tw) {
			return "";
		}
		return dateAsString;
	}
	
	public static String toReadableIp(String theIp) {
		if (theIp == null) {
			theIp = "";
		}
		return theIp;
	}
	
	public static String cleanLocalScopedIPv6(String theIpv6) {
		if (theIpv6 != null) {
			int pos = theIpv6.indexOf('%');
			if (pos != -1) {
				return theIpv6.substring(0, pos-1);
			}
		}
		return theIpv6;
	}
	
	public static String toReadableDate(String inputDate) {
		Date input = null;
		String dateAsString = "";
		DateFormat inFormat = new SimpleDateFormat(SIMPLE_PATTERN);
		DateFormat outFormat = DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.MEDIUM);
		try {
			input = inFormat.parse(inputDate);
			dateAsString = outFormat.format(input);
			
		} catch (Throwable tw) {
			return inputDate;
		}
		return dateAsString;
	}
	
	public static String calculateTimeAgo(Date date) {    	
    	Calendar currentDate = new GregorianCalendar();
    	long currentEpoc = currentDate.getTimeInMillis();
    	Long dateEpoc = date.getTime();
    	
		if (dateEpoc != null) {
    		long differenceEpoc = currentEpoc - dateEpoc;
    		int numericalBit = 0;
    		String textBit = "";
    		if (differenceEpoc > oneYear) {
    			numericalBit = (int)(differenceEpoc / oneYear);
    			textBit = " year";
    		} else if (differenceEpoc > oneMonth) {
    			numericalBit = (int)(differenceEpoc / oneMonth);
    			textBit = " month";
    		} else if (differenceEpoc > oneWeek) {
    			numericalBit = (int)(differenceEpoc / oneWeek);
    			textBit = " week";
    		} else if (differenceEpoc > oneDay) {
    			numericalBit = (int)(differenceEpoc / oneDay);
    			textBit = " day";
    		} else if (differenceEpoc > oneHour) {
    			numericalBit = (int)(differenceEpoc / oneHour);
    			textBit = " hour";
    		} else if (differenceEpoc > oneMinute) {
    			numericalBit = (int)(differenceEpoc / oneMinute);
    			textBit = " minute";
    		} else if (differenceEpoc > oneSecond) {
    			numericalBit = (int)(differenceEpoc / oneSecond);
    			textBit = " second";
    		} 
    		
    		StringBuffer sb = new StringBuffer();
    		sb.append(numericalBit);
    		sb.append(textBit);
    		if (numericalBit > 1 || numericalBit == 0) {
    			sb.append("s");
    		}
    		sb.append(" ago");
    		return sb.toString();
    	}
    	return "";
    }
	
	public static String convertShortDateToHumanReadableTimeAgo(String inputDate) { 
		if (inputDate != null && inputDate.length() > 0) {
			Date input = null;
			DateFormat inFormat = new SimpleDateFormat(SIMPLE_PATTERN);
			DateFormat inFormatOld = new SimpleDateFormat(SIMPLE_PATTERN_OLD);
			try {
				input = inFormat.parse(inputDate);
			} catch (ParseException e) {
				try {
					input = inFormatOld.parse(inputDate);
				} catch (ParseException e1) {
					
				}
			}
			if (input != null) {
				Long dateEpoc = input.getTime();
				return convertDateEpocToHumanReadableTimeAgo(dateEpoc);
			}
		}
		return "";
	}
	
	public static String convertStringToHumanReadableTimeAgo(String dateToConvert) {
		if (dateToConvert != null && dateToConvert.length() > 0) {
			Long dateEpoc = getDateFromString(dateToConvert, "MM/dd/yyyy HH:mm:ss aa", "yyyy-MM-dd'T'HH:mm:ss'Z'");
			return convertDateEpocToHumanReadableTimeAgo(dateEpoc);
		}
		return "";
	}
	
	public static String convertDateEpocToHumanReadableTimeAgo(Long dateEpoc) { 		
    	Calendar currentDate = new GregorianCalendar();
    	long currentEpoc = currentDate.getTimeInMillis();
		if (dateEpoc != null) {
    		long differenceEpoc = currentEpoc - dateEpoc;
    		int numericalBit = 0;
    		String textBit = "";
    		if (differenceEpoc > oneYear) {
    			numericalBit = (int)(differenceEpoc / oneYear);
    			textBit = " year";
    		} else if (differenceEpoc > oneMonth) {
    			numericalBit = (int)(differenceEpoc / oneMonth);
    			textBit = " month";
    		} else if (differenceEpoc > oneWeek) {
    			numericalBit = (int)(differenceEpoc / oneWeek);
    			textBit = " week";
    		} else if (differenceEpoc > oneDay) {
    			numericalBit = (int)(differenceEpoc / oneDay);
    			textBit = " day";
    		} else if (differenceEpoc > oneHour) {
    			numericalBit = (int)(differenceEpoc / oneHour);
    			textBit = " hour";
    		} else if (differenceEpoc > oneMinute) {
    			numericalBit = (int)(differenceEpoc / oneMinute);
    			textBit = " minute";
    		} else {
    			numericalBit = (int)(differenceEpoc / oneSecond);
    			textBit = " second";
    		} 
    		
    		StringBuffer sb = new StringBuffer();
    		sb.append(numericalBit);
    		sb.append(textBit);
    		if (numericalBit > 1 || numericalBit == 0) {
    			sb.append("s");
    		}
    		sb.append(" ago");
    		return sb.toString();
		}
    	return "";
    }

    private static Long getDateFromString(String date, String convertTo, String formatTo) {
    	SimpleDateFormat datePattern = null;
    	SimpleDateFormat parsedDatePattern = null;
    	SimpleDateFormat patternForCalendar = null;
    	Date dateToConvert = null;
    	String finalDate = "";
    	Calendar currentDate = new GregorianCalendar();
    	Long dateEpoc = null;
    	
    	datePattern = new SimpleDateFormat(convertTo);
    	parsedDatePattern = new SimpleDateFormat(formatTo);
    	patternForCalendar = new SimpleDateFormat(convertTo);
    	try {
    		dateToConvert = (Date) parsedDatePattern.parse(date);
    		finalDate = datePattern.format(dateToConvert);
    		currentDate.setTime(patternForCalendar.parse(finalDate));
    		dateEpoc = dateToConvert.getTime();
		} catch (Exception e) {
			System.out.println("Date formatter failed" + e);
		}
		return dateEpoc;
    }
	
	public static void main(String[] args) {
		System.out.println(toReadableIp("127.0.0.12"));
		System.out.println(toReadableIp(null));
		System.out.println(toReadableDate("4/18/13 12:17 AM"));
		System.out.println(toReadableDate("03/08/15 04:29:24 PM"));
		try {
        	System.out.println(convertShortDateToHumanReadableTimeAgo("4/30/12 11:58:42 AM"));
        } catch (Exception e) {
            e.printStackTrace();
        }
	}
}
