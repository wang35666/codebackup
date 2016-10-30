/*
 * TestString
 *
 * 2016年10月30日
 *
 * All rights reserved. This material is confidential and proprietary to 7ROAD
 */
package com.road.test;

/**
 * @author wangfei
 *
 */
public class TestString {

	public void string() {
		String string = new String();
		for (int i = 0; i < 10000; i++) {
			string += "aaa";
		}
	}

	public void stringBuilder() {
		StringBuilder stringBuilder = new StringBuilder();
		for (int i = 0; i < 10000; i++) {
			stringBuilder.append("aaa");
		}
	}
	
	public void stringBuffer() {
		StringBuffer stringBuffer = new StringBuffer();
		for(int i=0; i<10000; i++){
			stringBuffer.append("aaa");
		}
	}
	
	public static void main(String[] args) {
		long start = 0;
		TestString testString = new TestString();
		
		start = System.currentTimeMillis();
		testString.string();
		System.err.println((System.currentTimeMillis() - start));
		
		
		start = System.currentTimeMillis();
		testString.stringBuffer();
		System.err.println((System.currentTimeMillis() - start));
		
		start = System.currentTimeMillis();
		testString.stringBuilder();
		System.err.println((System.currentTimeMillis() - start));
	}
}
