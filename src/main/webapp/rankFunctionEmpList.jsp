<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%
	// 현재페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	//db연결
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "hr";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	
	/*---------- 1) 페이징 -----------*/
	//출력할 총행의 수 
	int totalRow = 0;
	String totalRowSql = "select count(*) from employees";
	PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
	ResultSet totalRowRs = totalRowStmt.executeQuery();
	if(totalRowRs.next()) {
		totalRow = totalRowRs.getInt(1); // totalRowRs.getInt("count(*)")
	}
	
	//페이지당 출력할 행의 수s
	int rowPerPage = 10;
	//시작 행번호
	int beginRow = (currentPage-1)*rowPerPage + 1;
	//마지막 행번호
	int endRow = beginRow + (rowPerPage -1);
	if(endRow > totalRow){
		endRow = totalRow;
	}
	
	//----------- 페이지 네이게이션 페이징 1.2.3.4.5....-----------
	int pagePerPage = 10;
	/*	cp	minPage ~ maxPage
		1		1	~	10
		2		1	~	10	
		.
		10		1	~	10
		11		11	~	20
		12		11	~	10
		.
		20		11	~	20
		
	minPage = (currentPage-1) / pagePerPage * pagePerPage + 1
	maxPage = minPage + (pagePerPage - 1)
	maxPage > lagePage --> maxPage = lastPage
	*/
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage +1;
	}
	
	int minPage = (((currentPage-1) / pagePerPage) * pagePerPage) + 1;
	int maxPage = minPage + (pagePerPage - 1);
	
	if(maxPage > lastPage) {
		maxPage = lastPage;
	}
	
	/*---------- 2) 테이블 출력 -----------*/
	/*  
	select 번호, 사원번호, 이름, 급여, 급여순위 from 
	(select rownum 번호, 사원번호, 이름, 급여, 급여순위 from 
	(select employee_id 사원번호, last_name 이름, salary 급여, rank() over(order by salary desc) 급여순위 from employees))
	where 번호 between ? and ?;
	*/
	String sql = "select 번호, 사원번호, 이름, 급여, 급여순위 from (select rownum 번호, 사원번호, 이름, 급여, 급여순위 from (select employee_id 사원번호, last_name 이름, salary 급여, rank() over(order by salary desc) 급여순위 from employees))where 번호 between ? and ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, endRow);
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	while(rs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("번호", rs.getInt("번호")); 
		m.put("사원번호", rs.getInt("사원번호")); 
		m.put("이름", rs.getString("이름")); 
		m.put("급여", rs.getInt("급여")); 
		m.put("급여순위", rs.getInt("급여순위")); 
		list.add(m);
	}
	System.out.print(list.size() +"< - list.size()");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h2></h2>
	<table border ="1">
		<tr>
			<th>번호</th>
			<th>사원번호</th>
			<th>이름</th>
			<th>급여</th>
			<th>급여순위</th>
		</tr>
		<%
			for(HashMap<String, Object> m : list) {
		%>
		
		<tr>
			<td><%=(Integer)(m.get("번호"))%></td>
			<td><%=(Integer)(m.get("사원번호"))%></td>
			<td><%=(String)(m.get("이름"))%></td>
			<td><%=(Integer)(m.get("급여"))%></td>
			<td><%=(Integer)(m.get("급여순위"))%></td>
		<tr>
		<%
			}
		%>	
	</table>
	<!---------------- 페이징--------------------->
		<%
		if(minPage > 1) {
		%>
				<a href="./rankFunctionEmpList.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>	
		<%
			}
		
		for(int i = minPage; i<=maxPage; i=i+1) {
			if(i == currentPage) {
		%>
				<span><%=i%></span>&nbsp;
		<%			
			} else {		
		%>
				<a href="./rankFunctionEmpList.jsp?currentPage=<%=i%>"><%=i%></a>&nbsp;	
		<%	
			}
		}
		
		if(maxPage != lastPage) {
		%>
			<!--  maxPage + 1 -->
			<a href="./windowsFuntionEmpList.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>
		<%
		}
		%>
</body>
</html>