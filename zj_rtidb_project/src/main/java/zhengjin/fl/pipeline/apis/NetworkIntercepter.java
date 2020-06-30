package zhengjin.fl.pipeline.apis;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;

public final class NetworkIntercepter implements Interceptor {

	private static final Logger LOGGER = LoggerFactory.getLogger(NetworkIntercepter.class);

	@Override
	public Response intercept(Chain chain) throws IOException {
		Request request = chain.request();
		String url = request.url().toString();
		String requestBody = HttpUtils.getRequestBody(request);

		Response response = null;
		String responseCode = "-1";
		long start = System.currentTimeMillis();
		try {
			response = chain.proceed(request);
			responseCode = String.valueOf(response.code());
		} finally {
			String duration = String.valueOf(System.currentTimeMillis() - start);
			LOGGER.info("requestUrl={}, requestBody={}, responseCode={}, responseTime={}ms", url, requestBody,
					responseCode, duration);
		}

		return response;
	}

}
