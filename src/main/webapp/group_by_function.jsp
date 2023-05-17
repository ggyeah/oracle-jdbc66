<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

/* group by */
String sql = "select department_id, job_id, count(*) from employees group by department_id, job_id";
PreparedStatement stmt = conn.prepareStatement(sql);
ResultSet rs = stmt.executeQuery();

ArrayList<HashMap<String, Object>> list = new ArrayList<>();

while(rs.next()) {
HashMap<String, Object> m = new HashMap<String, Object>();
m.put("department_id", rs.getInt("department_id")); 
m.put("job_id", rs.getString("job_id")); 
m.put("count(*)", rs.getInt("count(*)")); 
list.add(m);
}
System.out.println(list);

/* rollup */
String rollupSql = "select department_id, job_id, count(*) from employees group by rollup(department_id, job_id)";
PreparedStatement rollupStmt = conn.prepareStatement(rollupSql);
ResultSet rollupRs = rollupStmt.executeQuery();

ArrayList<HashMap<String, Object>> rolluplist = new ArrayList<>();

while(rollupRs.next()) {
HashMap<String, Object> r = new HashMap<String, Object>();
r.put("department_id", rollupRs.getInt("department_id")); 
r.put("job_id", rollupRs.getString("job_id")); 
r.put("count(*)", rollupRs.getInt("count(*)")); 
rolluplist.add(r);
}

/* cube */
String cubeSql = "select department_id, job_id, count(*) from employees group by cube(department_id, job_id)";
PreparedStatement cubeStmt = conn.prepareStatement(cubeSql);
ResultSet cubeRs = cubeStmt.executeQuery();

ArrayList<HashMap<String, Object>> cubelist = new ArrayList<>();

while(cubeRs.next()) {
HashMap<String, Object> c = new HashMap<String, Object>();
c.put("department_id", cubeRs.getInt("department_id")); 
c.put("job_id", cubeRs.getString("job_id")); 
c.put("count(*)", cubeRs.getInt("count(*)")); 
cubelist.add(c);
}

%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>group_by_function</title>	
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<body>
<div class="row">
	<div class="col-sm">
		<h2>group by</h2>
			<table class = "table">
				<tr>
					<th>department_id</th>
					<th>job_id</th>
					<th>count(*)</th>
				</tr>
				<%
					for(HashMap<String, Object> m : list) {
				%>
				
				<tr>
					<td><%=(Integer)(m.get("department_id"))%></td>
					<td><%=(m.get("job_id"))%></td>
					<td><%=(Integer)(m.get("count(*)"))%></td>
				<tr>
				<%
					}
				%>	
			</table>
		</div>
	<div class="col-sm">
		<h2>rollup</h2>
			<table class = "table">
				<tr>
					<th>department_id</th>
					<th>job_id</th>
					<th>count(*)</th>
				</tr>
				<%
					for(HashMap<String, Object> r : rolluplist) {
				%>
				
				<tr>
					<td><%=(Integer)(r.get("department_id"))%></td>
					<td><%=(r.get("job_id"))%></td>
					<td><%=(Integer)(r.get("count(*)"))%></td>
				<tr>
				<%
					}
				%>	
			</table>
		</div>
	<div class="col-sm">
		<h2>cube</h2>
			<table class = "table">
				<tr>
					<th>department_id</th>
					<th>job_id</th>
					<th>count(*)</th>
				</tr>
				<%
					for(HashMap<String, Object> c : cubelist) {
				%>
				
				<tr>
					<td><%=(Integer)(c.get("department_id"))%></td>
					<td><%=(c.get("job_id"))%></td>
					<td><%=(Integer)(c.get("count(*)"))%></td>
				<tr>
				<%
					}
				%>	
			</table>
		</div>
	</div>
</body>
</html>