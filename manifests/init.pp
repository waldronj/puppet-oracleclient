class windowsoracle{

  $content= "oracle.install.responseFileVersion=/oracle/install/rspfmt_clientinstall_response_schema_v12.1.0\n
    INVENTORY_LOCATION=C:\Program Files\Oracle\Inventory\n
    SELECTED_LANGUAGES=en\n
    ORACLE_HOME=c:\oracle\product\12.1.0\client_1\n
    ORACLE_BASE=c:\oracle\n
    oracle.install.IsBuiltInAccount=true\n
    oracle.install.client.installType=Administrator\n
    oracle.installer.autoupdates.option=SKIP_UPDATES"

  $oracleInstall= "C:\winx64_12c_client\client\\setup.exe -silent -responseFile C:\winx64_12c_client\client\\response\client.rsp"

  file{ 'C:/winx64_12c_client.zip':
    ensure              => present,
    source              => 'puppet:///modules/puppet-oracleclient/winx64_12c_client.zip',
    source_permissions  => 'ignore',
  }->
  exec{'unzipOracleClient':
    command  => "\"C:\\Program Files (x86)\\7-zip\\7z.exe\" -y x C:\\winx64_12c_client.zip -oc:\\winx64_12c_client",
    creates  => 'C:/winx64_12c_client/client/setup.ini',
    provider => windows,
  }->
  file{ 'C:/winx64_12c_client/client/response/client.rsp':
    ensure              => present,
    content             => $content,
    source_permissions  => 'ignore',
    provider            => 'windows',
  }->
  file{'c:/oracleInstall.ps1':
    content => $oracleInstall,
    source_permissions => 'ignore',
    provider           => 'windows',
  }->
  exec{'installOracleClient':
    command => "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -executionpolicy remotesigned -file C:/oracleInstall.ps1",
    creates  => 'C:\\oracle\\product\\12.1.0\\client_1\\owm\\jlib\\owm-3_0.jar',
    provider => windows,
  }
}
