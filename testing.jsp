<%-- 
    Document   : testing
    Created on : Feb 9, 2019, 3:30:31 PM
    Author     : TKM 7
--%>


<%@page import="javax.xml.bind.DatatypeConverter"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>

        <%
            Class.forName("com.mysql.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/products";
            String userName = "root";
            String password = "root";
            int x2 = 0, x3 = 0;
            String vendorid = "", categoryid = "", subcatid = "", brandid = "", modelid = "";
            Connection conn = DriverManager.getConnection(url, userName, password);

            String q2 = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE table_schema = 'products' AND table_name = 'feature_pro'";
            Statement st234 = conn.createStatement();
            ResultSet rs234 = st234.executeQuery(q2);
            if (rs234.next()) {

                x2 = rs234.getInt("count(*)");
                System.out.println("count......" + x2);
                x3 = (x2 - 40) / 2;
                System.out.println("raogopwwwq..x3.." + x3);
            }

            Statement st = conn.createStatement();
            ResultSet rs1 = st.executeQuery("select * from feature_pro");
            while (rs1.next()) {
                vendorid = rs1.getString("vendorid");
                categoryid = rs1.getString("categoryid");
                subcatid = rs1.getString("subcatid");
                brandid = rs1.getString("brandid");
                modelid = rs1.getString("modelid");
                System.out.println("vendorid..." + vendorid);

                ServletContext ctx = getServletContext();
                String path = "adupload//" + rs1.getString("vendorid") + "//" + rs1.getString("categoryid") + "//" + rs1.getString("subcatid") + "//" + rs1.getString("brandid") + "//" + rs1.getString("modelid");
                System.out.println("path..." + path);
                String checkpath = ctx.getInitParameter("location");
                String mainPath = checkpath + path;
                System.out.println("mainPath..." + mainPath);

                try {
                    File file = new File(mainPath);
                    if (file.exists() && file.isDirectory()) {

                        File getfile[] = file.listFiles();

                        String realpath = mainPath + "//" + getfile[0].getName();

                        BufferedImage bImage = ImageIO.read(new File(realpath));
                        ByteArrayOutputStream baos = new ByteArrayOutputStream();
                        ImageIO.write(bImage, "jpg", baos);
                        baos.flush();
                        byte[] imageInbyteArr = baos.toByteArray();
                        baos.close();
                        String b64 = DatatypeConverter.printBase64Binary(imageInbyteArr);


        %>
        <div class="card-body">
            <a href="showproducts.jsp?Advid=<%=rs1.getString("Advid")%>&vid=<%=rs1.getString("vendorid")%>">  
                <img  src="data:image/jpg;base64, <%=b64%>" alt="<%= realpath%>" class="img-thumbnail"  width="200" height="150" id="proimg">
            </a>
        </div>
        <%   }
                } catch (Exception e) {
                }
            }
        %>
    </body>
</html>
