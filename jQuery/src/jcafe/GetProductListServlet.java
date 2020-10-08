package jcafe;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class GetProductListServlet
 */
@WebServlet("/GetProductListServlet")
public class GetProductListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetProductListServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		response.getWriter().append("Served at: ").append(request.getContextPath())
//		.append(" Hello Servlet");
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=UTF-8");
		ProductDAO dao = new ProductDAO();
		List<ProductVO> list = dao.getProductList();
		// [{"item_no":"been_001", "item":"콜롬비아 원두".....},{},{}]
		int lastData = list.size();
		int i = 0;
		String json = "[";
		for(ProductVO vo : list) {
			i++;
			json += "{\"item_no\":\"" + vo.getItemNo() + "\""// 
					+ ",\"item\":\"" + vo.getItem() + "\""//
					+ ",\"category\":\"" + vo.getCategory() + "\""// 
					+ ",\"price\":\"" + vo.getPrice() + "\""// 
					+ ",\"link\":\"" + vo.getLink() + "\""// 
					+ ",\"content\":\"" + vo.getContent() + "\""// 
					+ ",\"likeIt\":\"" + vo.getLikeIt() + "\""// 
					+ ",\"alt\":\"" + vo.getAlt() + "\""// 
					+ ",\"image\":\"" + vo.getImage() + "\""//
					+ "}";
			if(i != lastData)
				json += ",";
		}
		json += "]";
		response.getWriter().append(json);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
