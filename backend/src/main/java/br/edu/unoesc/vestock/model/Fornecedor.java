package br.edu.unoesc.vestock.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrimaryKeyJoinColumn;
import jakarta.persistence.Table;

/**
 * Representa um fornecedor.
 */
@Entity
@Table(name = "fornecedor")
@PrimaryKeyJoinColumn(name = "codpes")
public class Fornecedor extends Pessoa {

	/** CNPJ do fornecedor. */
	@Column(name = "cnpfor", length = 18, nullable = false, unique = true)
	private String cnpj;

	/** Nome fantasia do fornecedor. */
	@Column(name = "nomfanfor", length = 100)
	private String nomeFantasia;

	@ManyToOne
	@JoinColumn(name = "codloj", nullable = false)
	private Loja loja;

	public Fornecedor() {

	}

	public Fornecedor(Integer id, String nome, String email, Character sexo, String telefone, String rua, String bairro,
			String cidade, String estado, String cnpj, String nomeFantasia) {
		super(id, nome, email, sexo, telefone, rua, bairro, cidade, estado);
		this.cnpj = cnpj;
		this.nomeFantasia = nomeFantasia;
	}

	// Getters e Setters

	public String getCnpj() {
		return cnpj;
	}

	public void setCnpj(String cnpj) {
		this.cnpj = cnpj;
	}

	public String getNomeFantasia() {
		return nomeFantasia;
	}

	public void setNomeFantasia(String nomeFantasia) {
		this.nomeFantasia = nomeFantasia;
	}

	public Loja getLoja() {
		return loja;
	}

	public void setLoja(Loja loja) {
		this.loja = loja;
	}
}