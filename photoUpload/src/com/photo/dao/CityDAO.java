package com.photo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.photo.util.Dbcon;
import com.photo.util.Loggers;

public class CityDAO {
	private Connection conn;
	private PreparedStatement ptst;
	private ResultSet rs;
	public int getID(String city){
		conn = Dbcon.getCon();
		try {
			ptst = conn.prepareStatement("select cityid from citys where city = ?");
			ptst.setString(1, city);
			rs = ptst.executeQuery();
			while(rs.next()){
				return rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			Loggers.log().logW(getClass(), e.getMessage());
		}finally{
			this.close();
		}
		return -1;
	}
	public int insert(String city){
		conn = Dbcon.getCon();
		try {
			ptst = conn.prepareStatement("insert into citys(city) values(?)");
			ptst.setString(1, city);
			System.out.println(city);
			rs = ptst.getGeneratedKeys();
			while(rs.next()){
				return rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			Loggers.log().logW(getClass(), e.getMessage());
		}finally{
			this.close();
		}
		return -1;
	}
	private void close(){
		try {
			if(rs != null)
				rs.close();
			if(ptst != null)
				ptst.close();
			if(conn != null);
				conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			Loggers.log().logW(getClass(), e.getMessage());
		}
	}
}
