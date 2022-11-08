package com.example.firstJavaCode;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class FirstTest {

	MyFirstController controller = new MyFirstController();
	/*
	 * @Test void test() { fail("Not yet implemented"); }
	 */

	@Test
	void testAdd() {
		assertEquals(5, controller.add(2, 3));
	}

}
