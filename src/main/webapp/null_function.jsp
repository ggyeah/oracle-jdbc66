<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<% 
//db연결
String driver = "oracle.jdbc.driver.OracleDriver";
String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
String dbuser = "hr";
String dbpw = "java1234";
Class.forName(driver);
Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);

/*--------------- nvl----------------- */
String nvlsql = "select 이름, nvl(일분기, 0) 일분기 from 실적";
PreparedStatement nvlstmt = conn.prepareStatement(nvlsql);
ResultSet nvlRs = nvlstmt.executeQuery();

ArrayList<HashMap<String, Object>> nvllist = new ArrayList<>();

while(nvlRs.next()) {
HashMap<String, Object> nvl = new HashMap<String, Object>();
nvl.put("이름", nvlRs.getString("이름")); 
nvl.put("일분기", nvlRs.getInt("일분기")); 
nvllist.add(nvl);
}
System.out.println(nvllist);

/*--------------- nvl2 -----------------*/
String nvl2sql = "select 이름, nvl2(일분기, 'success', 'fail') 일분기 from 실적";
PreparedStatement nvl2stmt = conn.prepareStatement(nvl2sql);
ResultSet nvl2Rs = nvl2stmt.executeQuery();

ArrayList<HashMap<String, Object>> nvl2list = new ArrayList<>();

while(nvl2Rs.next()) {
HashMap<String, Object> nvl2 = new HashMap<String, Object>();
nvl2.put("이름", nvl2Rs.getString("이름")); 
nvl2.put("일분기", nvl2Rs.getString("일분기")); 
nvl2list.add(nvl2);
}
System.out.println(nvl2list);

/* ---------------nullif-------------------- */
String nullifsql = "select 이름, nullif(사분기, 100) 사분기 from 실적";
PreparedStatement nullifstmt = conn.prepareStatement(nullifsql);
ResultSet nullifRs = nullifstmt.executeQuery();

ArrayList<HashMap<String, Object>> nulliflist = new ArrayList<>();

while(nullifRs.next()) {
HashMap<String, Object> nullif = new HashMap<String, Object>();
nullif.put("이름", nullifRs.getString("이름")); 
nullif.put("사분기", nullifRs.getInt("사분기")); 
nulliflist.add(nullif);
}
System.out.println(nulliflist);

/*--------------- coalesce----------------- */
String coalescesql ="select 이름, coalesce(일분기, 이분기, 삼분기, 사분기) 전체 from 실적";
PreparedStatement coalescestmt = conn.prepareStatement(coalescesql);
ResultSet coalesceRs = coalescestmt.executeQuery();

ArrayList<HashMap<String, Object>> coalescelist = new ArrayList<>();

while(coalesceRs.next()) {
HashMap<String, Object> c = new HashMap<String, Object>();
c.put("이름", coalesceRs.getString("이름")); 
c.put("전체", coalesceRs.getInt("전체"));
coalescelist.add(c);
}
System.out.println(coalescelist);


%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
table, td, th {
  border : 1px solid black;
  border-collapse : collapse;
};
</style>
</head>
<body>
<!----------------nvl--------------->
	<h2>1. select 이름, nvl(일분기, 0) from 실적;</h2>
		<table>
			<tr>
				<th>이름</th>
				<th>nvl</th>
			</tr>
			<%
				for(HashMap<String, Object> nvl : nvllist) {
			%>
			
			<tr>
				<td><%=(nvl.get("이름"))%></td>
				<td><%=(Integer)(nvl.get("일분기"))%></td>
			<tr>
			<%
				}
			%>	
		</table>
<!----------------nvl2--------------->
	<h2>2. select 이름, nvl2(일분기, 'success', 'fail') from 실적;</h2>
		<table>
			<tr>
				<th>이름</th>
				<th>nvl2</th>
			</tr>
			<%
				for(HashMap<String, Object> nvl2 : nvl2list) {
			%>
			
			<tr>
				<td><%=(nvl2.get("이름"))%></td>
				<td><%=(nvl2.get("일분기"))%></td>
			<tr>
			<%
				}
			%>	
		</table>
<!----------------nullif--------------->
	<h2>3. select 이름, nullif(사분기, 100) from 실적;</h2>
		<table>
			<tr>
				<th>이름</th>
				<th>nullif</th>
			</tr>
			<%
				for(HashMap<String, Object> nullif : nulliflist) {
			%>
			
			<tr>
				<td><%=(nullif.get("이름"))%></td>
				<td><%=(Integer)(nullif.get("사분기"))%></td>
			<tr>
			<%
				}
			%>	
		</table>
<!----------------coalesce--------------->
	<h2>4. select 이름, coalesce(일분기, 이분기, 삼분기, 사분기) from 실적;</h2>
		<table>
			<tr>
				<th>이름</th>
				<th>coalesce</th>
			</tr>
			<%
				for(HashMap<String, Object> c : coalescelist) {
			%>
			
			<tr>
				<td><%=(c.get("이름"))%></td>
				<td><%=(Integer)(c.get("전체"))%></td>
			<tr>
			<%
				}
			%>	
		</table>

		
</body>
</html>