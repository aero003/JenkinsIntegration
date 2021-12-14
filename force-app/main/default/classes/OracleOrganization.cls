public with sharing virtual class OracleOrganization extends OracleObject {
	
	public String name {get; set;}

	public CustomFields customFields {get; set;}

	public class CustomFields {
		public c c;
	}

	public class c {
		public String account_name;
		public Object alt_phone;
		public String brand;
		public Object fax;
		public Object livevault_product;
		public String owner_name;
		public Object parent_id;
		public Object phone;
		public Object primary_contact;
		public String record_type_name;
		public Object salesforce_date_created;
		public Object salesforce_id;
		public Object salesforce_source;
		public Object secondary_partner_contact;
		public String status;
		public Object website;
		public String customer_id;
	}

	public OracleOrganization() {
		
	}

}