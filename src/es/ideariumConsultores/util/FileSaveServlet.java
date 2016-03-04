package es.ideariumConsultores.util;

import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class FileSaveServlet extends HttpServlet {
    private static final int BYTES_DOWNLOAD = 1024;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException,
                                                                                       IOException {
			doPost(request, response);
		}

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//				request.setCharacterEncoding("UTF-8"); 
				ByteArrayOutputStream baos = new ByteArrayOutputStream();

				//Fake code simulating the copy
				//You can generally do better with nio if you need...
				//And please, unlike me, do something about the Exceptions :D
				byte[] buffer = new byte[1024];
				int len;
				String s = "";

				while ((len = request.getInputStream().read(buffer)) > -1 ) {
					baos.write(buffer, 0, len);
					s += new String(buffer);
				}
				baos.flush();

				byte[]byt = baos.toByteArray();
				String decoded = java.net.URLDecoder.decode(new String(byt), "UTF-8");
				String[] parts = decoded.split("&");
				String content = "";
				String filename = "";
				if (parts.length == 2) {
					if (parts[0].startsWith("txt=")) {
							// quitar la primera parte txt= que ocupa 4 caracteres
						content = parts[0].substring(4);
					} else if (parts[0].startsWith("filename=")) {
						filename = parts[0].split("=")[1];
					}
					if (parts[1].startsWith("txt=")) {
							// quitar la primera parte txt= que ocupa 4 caracteres
						content = parts[1].substring(4);
					} else if (parts[1].startsWith("filename=")) {
						filename = parts[1].split("=")[1];
					}
				}
				byte[]bytes = content.getBytes();


        response.setContentType("application/force-download");
				response.setHeader("Content-Transfer-Encoding", "binary");
        response.setHeader("Content-Disposition", "attachment;filename=\"" + filename + "\"");


        OutputStream os = response.getOutputStream();
        os.write(bytes, 0, bytes.length);
				System.out.println(decoded);
        os.flush();
        os.close();


/*
        request.setCharacterEncoding("UTF-8"); 
        response.setContentType("application/force-download");
				response.setHeader("Content-Transfer-Encoding", "binary");
        response.setHeader("Content-Disposition", "attachment;filename=\"idearagon.gml\"");

        //String s = "Test\n\nText file contects!!";		
        //InputStream input = new ByteArrayInputStream(s.getBytes("UTF8"));

        int read = 0;
        byte[] bytes = new byte[BYTES_DOWNLOAD];
        OutputStream os = response.getOutputStream();

        while ((read = request.getInputStream().read(bytes)) != -1) {
            os.write(bytes, 0, read);
						System.out.println(bytes);
        }
        os.flush();
        os.close();*/
    }
}
