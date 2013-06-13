package com.photo.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import com.photo.bean.Photo;
import com.photo.dao.CityDAO;
import com.photo.dao.ProvDAO;
import com.photo.util.Dbcon;
import com.photo.util.Loggers;

public class PhotoService {
	public boolean insert(Photo photo,Connection conn){
		try{
			conn.setAutoCommit(false);
			PreparedStatement ptst;
			ResultSet rs;
			
			int cityId = new CityDAO().getID(photo.getCity());
			int provId = new ProvDAO().getID(photo.getProv());
			if(cityId < 0){
				ptst = conn.prepareStatement("insert into citys(city) values(?)");
				ptst.setString(1, photo.getCity());
				ptst.executeUpdate();
				rs = ptst.getGeneratedKeys();
				while(rs.next()){
					cityId = rs.getInt(1);
				}
//				System.out.println(111111);
			}
//			System.out.println("city"+cityId);
			if(provId < 0){
				ptst = conn.prepareStatement("insert into provs(prov) values(?)");
				ptst.setString(1, photo.getProv());
				ptst.executeUpdate();
				rs = ptst.getGeneratedKeys();
				while(rs.next()){
					provId = rs.getInt(1);
				}
//				System.out.println(2222222);
			}
//			System.out.println("prov"+provId);
			ptst = conn.prepareStatement("insert into addrs(cityid,provid) values(?,?)");
			ptst.setInt(1, cityId);
			ptst.setInt(2, provId);
			ptst.executeUpdate();
			rs = ptst.getGeneratedKeys();
			int addId = -1;
			while(rs.next()){
				addId = rs.getInt(1);
			}
//			System.out.println("add"+addId);
			ptst = conn.prepareStatement("insert into photos(filename,filedate,addid,city,prov,county,lat,log) values(?,?,?,?,?,?,1,1)");
//			System.out.println(photo.getFiledate());
			ptst.setString(1, photo.getFilename());
			ptst.setString(2, photo.getFiledate());
			ptst.setInt(3, addId);
			ptst.setString(4, photo.getCity());
			ptst.setString(5, photo.getProv());
			ptst.setString(6, photo.getCounty());
//			System.out.println(photo.getFilename());
//			System.out.println(photo.getFiledate());
//			System.out.println(photo.getCity());
//			System.out.println(photo.getProv());
//			System.out.println(33333);
//			System.out.println(photo.getCounty());
//			System.out.println("111"+ptst.execute());
//			rs = ptst.getGeneratedKeys();
			
			conn.commit();
		}catch (SQLException e) {
//			e.printStackTrace();
//			 TODO: handle exception
			try {
				conn.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				Loggers.log().logW(getClass(), e.getMessage());
			}
		}finally{
			try {
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				Loggers.log().logW(getClass(), e.getMessage());
			}
		}
		return true;
	}
}
