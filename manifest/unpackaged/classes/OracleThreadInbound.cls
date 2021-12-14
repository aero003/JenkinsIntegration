public with sharing class OracleThreadInbound extends OracleThread {
	public OracleThreadInbound() {
		
	}

	public LookupById contact;

	public override void setContact(LookupById contact) {
		this.contact = contact;
	}
}