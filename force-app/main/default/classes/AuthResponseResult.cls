public class AuthResponseResult {

	public Result result;
    
	public class Data {
		public String access_token;
		public String token_type;
		public Integer expires_in;
		public String scope;
		public String jti;
	}

	public class Result {
		public Data data;
	}

	
	public static AuthResponseResult parse(String json) {
		return (AuthResponseResult) System.JSON.deserialize(json, AuthResponseResult.class);
	}
}