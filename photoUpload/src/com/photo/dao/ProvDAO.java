package com.photo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.photo.util.Dbcon;
import com.photo.util.Loggers;

public class ProvDAO {

	private Connection conn;
	private PreparedStatement ptst;
	private ResultSet rs;
	public int getID(String prov){
		conn = Dbcon.getCon();
		try {
			ptst = conn.prepareStatement("select provid from provs where prov = ?");
			ptst.setString(1, prov);
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
