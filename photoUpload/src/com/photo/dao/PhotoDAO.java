package com.photo.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.photo.bean.Photo;
import com.photo.service.PhotoService;
import com.photo.util.Dbcon;
import com.photo.util.Loggers;

public class PhotoDAO {
	private Connection conn;
	private PreparedStatement ptst;
	private ResultSet rs;
	public void insert(Photo photo) {
		conn = Dbcon.getCon();
		new PhotoService().insert(photo, conn);
	}
	
	public List<Photo> getList(){
		List<Photo> list = new ArrayList<Photo>();
		conn = Dbcon.getCon();
		try {
			ptst = conn.prepareStatement("select filename,filedate,citys.city city,provs.prov prov from photos,addrs,citys,provs where photos.addid = addrs.addrid and addrs.cityid = citys.cityid and addrs.provid = provs.provid");
			rs = ptst.executeQuery();
			while(rs.next()){
				Photo photo = new Photo();
				photo.setFilename(rs.getString("filename"));
				photo.setFiledate(rs.getString("filedate"));
				photo.setProv(rs.getString("prov"));
				photo.setCity(rs.getString("city"));
				list.add(photo);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally{
			this.close();
		}
		return list;
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
