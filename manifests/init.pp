#Alterando fuso horário
exec {"alterando-fuso-horario":
	command => "sudo bash -c 'ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime'",
	path => "/usr/bin:/bin/",
	user => "root",
}

#Criando o arquivo resolv.conf
file {"/etc/resolv.conf":
	owner => root,
	source =>"/vagrant/manifests/resolv.conf",
	require => Exec["alterando-fuso-horario"],
}

#Incluindo o proxy no yum.conf
file {"/etc/yum.conf":
	owner => root,
	source =>"/vagrant/manifests/yum.conf",
	require => File["/etc/resolv.conf"],
}

#Incluindo o /etc/hosts
file {"/etc/hosts":
	owner => root,
	source =>"/vagrant/manifests/hosts",
	require => File["/etc/yum.conf"],
}

#Executando o clean all depois de alterar o yum.conf
exec {"yum-clean":
	command => "sudo yum clean all",
	path => "/usr/bin:/bin/",
	user => "root",
	require => File["/etc/hosts"],
}

#Executando update do CentOS
exec {"atualizando-yum":
	command => "sudo yum update -y",
	path => "/usr/bin:/bin/",
	user => "root",
	timeout => 10000,
	require => Exec["yum-clean"],
}

#Instalando developer tools
exec {"instalando-developer-tools":
	command => "sudo yum groupinstall -y development",
	path => "/usr/bin:/bin/",
	user => "root",
	timeout => 10000,
	require => Exec["atualizando-yum"],
}

#Fazendo download Python 3.3 e descompactando
exec {"download-python-e-descompactando":
	command => "sudo bash -c 'wget http://www.python.org/ftp/python/3.3.3/Python-3.3.3.tar.xz;tar xf /home/vagrant/Python-3.3.3.tar.xz'",
	path => "/usr/bin:/bin/",
	user => "root",
	timeout => 10000,
	creates => "/home/vagrant/Python-3.3.3" ,
	require => Exec["instalando-developer-tools"],
}

#Configurando
exec {"configurando-python":
	command => "sudo bash -c 'cd /home/vagrant/Python-3.3.3; ./configure'",
	path => "/usr/bin:/bin/",
	user => "root",
	timeout => 10000,
	require => Exec["download-python-e-descompactando"],
}

#Instalando
exec {"instalando-python":
	command => "sudo bash -c 'make && make altinstall'",
	path => "/usr/bin:/bin/",
	user => "root",
	timeout => 10000,
	require => Exec["configurando-python"],
}



