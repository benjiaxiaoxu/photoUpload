package com.photo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


import com.photo.bean.Users;
import com.photo.util.Dbcon;
import com.photo.util.Loggers;

public class UserDAO {
	private Connection conn;
	private PreparedStatement ptst;
	private ResultSet rs;
	public boolean checkUser(Users user){
		conn = Dbcon.getCon();
		try {
			ptst = conn.prepareStatement("select count(1) from users where username = ? and password = ?");
			ptst.setString(1, user.getUsername());
			ptst.setString(2, user.getPassword());
			rs = ptst.executeQuery();
			while(rs.next()){
				int i = rs.getInt(1);
				if (i>0) {
					System.out.println(111);
					return true;
				}
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			Loggers.log().logW(getClass(), e.getMessage());
		}finally{
			this.close();
		}
		return false;
	}
	public boolean insertUser(Users user){
		conn = Dbcon.getCon();
		try{
			ptst = conn.prepareStatement("insert into Users(username,password) Values(?,?)");
			ptst.setString(1, user.getUsername());
			ptst.setString(2, user.getPassword());
			
		}catch (SQLException e) {
			// TODO Auto-generated catch block
			Loggers.log().logW(getClass(), e.getMessage());
		}finally{
			this.close();
		}
		return false;
	}
	private void close(){
		try {
			if(rs != null)
				rs.close();
			if(ptst != null)
				ptst.close();
			if(conn != null)
				conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			Loggers.log().logW(getClass(), e.getMessage());
		}
	}
}
