package com.example.firstJavaCode;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@ResponseBody
public class MyFirstController {

	@RequestMapping(path = "/add/{num1}/{num2}")
	public int add(@PathVariable int num1, @PathVariable int num2)
	{
		return num1+num2;
	}
	
	@RequestMapping(path = "/sub/{num1}/{num2}")
	public int sub(@PathVariable int num1, @PathVariable int num2)
	{
		return num1-num2;
	}
	
	@RequestMapping(path = "/mul/{num1}/{num2}")
	public int mul(@PathVariable int num1, @PathVariable int num2)
	{
		return num1*num2;
	}
	
	@RequestMapping(path = "/div/{num1}/{num2}")
	public int div(@PathVariable int num1, @PathVariable int num2)
	{
		return num1/num2;
	}
}
