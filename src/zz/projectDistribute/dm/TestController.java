package zz.projectDistribute.dm;

import zz.projectDistribute.util.QQMap;

import static zz.projectDistribute.base.Res.*;

import java.util.Arrays;

public class TestController{
	
	public static void main(String[] args){
		System.out.println(Arrays.toString("a|b|".split("\\|",-1)));
	}
	
	public String text(String v,QQMap map) {
		
		try {
			
			throw new RuntimeException("TEST");
		}catch(Exception e) {
			throw e;
		}finally {
//			return v+" "+map;
		}
	}
	public Object jsp(QQMap map) {
		return map;
	}
	public Object echo(QQMap map) {
		return OK().data(map);
	}
}