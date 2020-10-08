package jcafe;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import common.ConnectDB;

public class ProductDAO {
	Connection conn;
	PreparedStatement pstmt;
	ResultSet rs;
	
	public ProductDAO() {
		conn = ConnectDB.getConnection();
	}
	
	// 한건 입력하는 기능.
	public void insertProduct(ProductVO vo) {
		String sql = "insert into product (item_no, item, category, price, link, "
			       + "content, like_it, alt, image) " + "values(?,?,?,?,?,?,?,?,?)";
		try {
			int r = 0;
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(++r, vo.getItemNo());
			pstmt.setString(++r, vo.getItem());
			pstmt.setString(++r, vo.getCategory());
			pstmt.setDouble(++r, vo.getPrice());
			pstmt.setString(++r, vo.getLink());
			pstmt.setString(++r, vo.getContent());
			pstmt.setDouble(++r, vo.getLikeIt());
			pstmt.setString(++r, vo.getAlt());
			pstmt.setString(++r, vo.getImage());
			
			r = pstmt.executeUpdate();
			System.out.println(r + "건 입력됨.");
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	
	// 한건 삭제하는 기능.
	public void deleteProduct(String itemNo) {
		String sql = "delete  product where item_no=?";
		try {
			int r = 0;
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, itemNo);
			r = pstmt.executeUpdate();
			  System.out.println(r + "건 삭제됨");
//			pstmt.executeUpdate(vo.getItemNo(), ++r);
//			pstmt.setString(++r, vo.getItem());
//			pstmt.setString(++r, vo.getCategory());
//			pstmt.setDouble(++r, vo.getPrice());
//			pstmt.setString(++r, vo.getLink());
//			pstmt.setString(++r, vo.getContent());
//			pstmt.setDouble(++r, vo.getLikeIt());
//			pstmt.setString(++r, vo.getAlt());
//			pstmt.setString(++r, vo.getImage());
			  
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	// 한건 조회하는 기능.
	public ProductVO getProduct(String itemNo) {
		String sql = "select * from product where item_no = ?";
		ProductVO vo = new ProductVO();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, itemNo); //파라메타
			rs = pstmt.executeQuery();
			if(rs.next()) {
				vo.setAlt(rs.getString("alt"));
				vo.setCategory(rs.getString("category"));
				vo.setContent(rs.getString("content"));
				vo.setImage(rs.getString("image"));
				vo.setItem(rs.getString("item"));
				vo.setItemNo(rs.getString("item_no"));
				vo.setLink(rs.getString("link"));
				vo.setLikeIt(rs.getDouble("like_it"));
				vo.setPrice(rs.getDouble("price"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}  finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return vo;
	}
	
	
	// 전체 조회하는 기능.
	public List<ProductVO> getProductList(){
		List<ProductVO> list = new ArrayList<>();
		String sql = "select * from product";
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductVO vo = new ProductVO();
				vo.setAlt(rs.getString("alt"));
				vo.setCategory(rs.getString("category"));
				vo.setContent(rs.getString("content"));
				vo.setImage(rs.getString("image"));
				vo.setItem(rs.getString("item"));
				vo.setItemNo(rs.getString("item_no"));
				vo.setLink(rs.getString("link"));
				vo.setLikeIt(rs.getDouble("like_it"));
				vo.setPrice(rs.getDouble("price"));
				list.add(vo);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return list;
	}
}
