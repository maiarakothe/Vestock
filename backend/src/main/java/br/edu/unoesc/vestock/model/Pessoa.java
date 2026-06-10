package br.edu.unoesc.vestock.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.Table;

/**
 * Representa uma pessoa no sistema e é usada como base para outras classes
 */

@Entity
@Table(name = "pessoa")
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class Pessoa {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "codpes")
	protected Integer id;

	@Column(name = "nompes", length = 80, nullable = false)
	protected String nome;

	@Column(name = "emapes", length = 80, nullable = false, unique = true)
	protected String email;

	@Column(name = "sexpes", length = 1, nullable = false)
	protected Character sexo;

	@Column(name = "telpes", length = 20, nullable = false)
	protected String telefone;

	@Column(name = "ruapes", length = 100, nullable = false)
	protected String rua;

	@Column(name = "baipes", length = 20, nullable = false)
	protected String bairro;

	@Column(name = "cidpes", length = 50, nullable = false)
	protected String cidade;

	@Column(name = "estpes", length = 20, nullable = false)
	protected String estado;

	public Pessoa() {
		super();
	}

	public Pessoa(Integer id, String nome, String email, Character sexo, String telefone, String rua, String bairro,
			String cidade, String estado) {
		super();
		this.id = id;
		this.nome = nome;
		this.email = email;
		this.sexo = sexo;
		this.telefone = telefone;
		this.rua = rua;
		this.bairro = bairro;
		this.cidade = cidade;
		this.estado = estado;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Character getSexo() {
		return sexo;
	}

	public void setSexo(Character sexo) {
		this.sexo = sexo;
	}

	public String getTelefone() {
		return telefone;
	}

	public void setTelefone(String telefone) {
		this.telefone = telefone;
	}

	public String getRua() {
		return rua;
	}

	public void setRua(String rua) {
		this.rua = rua;
	}

	public String getBairro() {
		return bairro;
	}

	public void setBairro(String bairro) {
		this.bairro = bairro;
	}

	public String getCidade() {
		return cidade;
	}

	public void setCidade(String cidade) {
		this.cidade = cidade;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

}
