public with sharing virtual class OracleThread extends OracleObject {
	public OracleThread() {
		super();
	}

	public Object mailHeader;
	public String text;
	public LookupById entryType;
	public LookupByName channel;
	public LookupById contentType;

	public virtual void setContact(LookupById contact) {

	}

}