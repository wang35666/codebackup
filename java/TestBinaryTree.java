/*
 * TestBinaryTree
 *
 * 2016年10月29日
 *
 * All rights reserved. This material is confidential and proprietary to 7ROAD
 */
package com.road.test;

/**
 * @author wangfei
 *
 */
public class TestBinaryTree {

	private int[] data;

	private int size;

	private int capacity;

	public TestBinaryTree() {
		capacity = 16;
		data = new int[capacity];
	}

	public void insert(int val) {
		int pos = size;
		data[pos] = val;
		size++;

		shiftUp(pos);

	}

	/**
	 * @param pos
	 */
	private void shiftUp(int pos) {
		while (pos > 0) {
			int parent = (pos - 1) / 2;

			if (data[parent] < data[pos])
				break;

			int tmp = data[parent];
			data[parent] = data[pos];
			data[pos] = tmp;

			pos = parent;
		}
	}

	public String toString() {
		String string = "";

		for (int i = 0; i < size; i++) {
			string += " ";
			string += data[i];
		}

		return string;
	}
	
	public void sort(){
		
		for (int i = size-1; i > 0; i--) {
			int tmp = data[0];
			data[0] = data[i];
			data[i] = tmp;
			
			minHeapFixDown(0, i);
		}
	}
	
	/**
	 * @param i
	 * @param len
	 */
	private void minHeapFixDown(int i, int len) {

		while (2 * i + 1 < len) {
			int minChild = 2 * i + 1;
			if (2 * i + 2 < len && data[2 * i + 1] > data[2 * i + 2]) {
				minChild = 2 * i + 2;
			}

			if (data[i] < data[minChild])
				break;

			int tmp = data[i];
			data[i] = data[minChild];
			data[minChild] = tmp;

			i = minChild;
		}

	}

	public static void main(String[] args) {

		TestBinaryTree binaryTree = new TestBinaryTree();
		binaryTree.insert(4);
		binaryTree.insert(6);
		binaryTree.insert(10);
		binaryTree.insert(20);
		binaryTree.insert(3);
		binaryTree.insert(1);

		System.err.println(binaryTree);
		
		binaryTree.sort();
		
		System.err.println(binaryTree);
	}
}
