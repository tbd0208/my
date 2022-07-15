package zz.projectDistribute.config;

import zz.projectDistribute.util.io.ftp.WebFtpClient;

public class DistributeInfo {
	
	private String serverGroupName;
	private String prePath;
	private WebFtpClient[][] list = new WebFtpClient[DistributeLevel.values().length][];
	
	public DistributeInfo(String serverGroupName,String svrPrePath,WebFtpClient...webFtpClients) {
		this.serverGroupName = serverGroupName;
		this.prePath = svrPrePath;
	}
	
	public String getServerGroupName() {
		return serverGroupName;
	}
	public String getPrePath() {
		return prePath;
	}

	public DistributeInfo put(DistributeLevel distributeLevel, WebFtpClient...webFtpClients) {
		list[distributeLevel.ordinal()] = webFtpClients;
		return this;
	}
	public WebFtpClient[] get(DistributeLevel distributeLevel) {
		return list[distributeLevel.ordinal()];
	}
}
