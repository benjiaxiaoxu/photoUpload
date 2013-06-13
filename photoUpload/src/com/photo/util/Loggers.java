package com.photo.util;

import org.apache.log4j.Logger;

public class Loggers {
	private static Loggers log = null;
	private Loggers(){}
	public static Loggers log(){
		if(log == null){
			log = new Loggers();
		}
		return log;
		
	}
	public void logW(Class<?> t,String err){
		org.apache.log4j.BasicConfigurator.configure();
		org.apache.log4j.Logger l = Logger.getLogger(t);
		l.error(err);
	}
}
