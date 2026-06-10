package br.edu.unoesc.vestock.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Representa a loja.
 */
@Entity
@Table(name = "loja")
public class Loja {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "codloj")
	private Integer id;

	/** Nome da loja. */
	@Column(name = "nomloj", length = 80, nullable = false)
	private String nome;

	/** Rua da loja. */
	@Column(name = "rualoj", length = 100)
	private String rua;

	/** Bairro da loja. */
	@Column(name = "bailoj", length = 50)
	private String bairro;

	/** Cidade da loja. */
	@Column(name = "cidloj", length = 50)
	private String cidade;

	/** Telefone de contato. */
	@Column(name = "telloj", length = 20)
	private String telefone;

	/** CNPJ da loja. */
	@Column(name = "cnploj", length = 18, unique = true)
	private String cnpj;

	public Loja() {

	}

	public Loja(Integer id, String nome, String rua, String bairro, String cidade, String telefone, String cnpj) {
		super();
		this.id = id;
		this.nome = nome;
		this.rua = rua;
		this.bairro = bairro;
		this.cidade = cidade;
		this.telefone = telefone;
		this.cnpj = cnpj;
	}

	// Getters e Setters

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

	public String getTelefone() {
		return telefone;
	}

	public void setTelefone(String telefone) {
		this.telefone = telefone;
	}

	public String getCnpj() {
		return cnpj;
	}

	public void setCnpj(String cnpj) {
		this.cnpj = cnpj;
	}
}
