package br.edu.unoesc.vestock.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/**
 * Representa um produto disponível para venda.
 */
@Entity
@Table(name = "produto")
public class Produto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "codpro")
    private Integer id;

    /** Nome do produto. */
    @Column(name = "nompro", length = 100, nullable = false)
    private String nome;

    /** Tamanho do produto. */
    @Column(name = "tampro", length = 10)
    private String tamanho;

    /** Cor do produto. */
    @Column(name = "corpro", length = 50)
    private String cor;

    /** Tipo/Categoria. */
    @Column(name = "tipro", length = 50)
    private String tipo;

    /** Custo de aquisição. */
    @Column(name = "custpro", precision = 10, scale = 2, nullable = false)
    private BigDecimal custo;

    /** Preço de venda. */
    @Column(name = "vendpro", precision = 10, scale = 2, nullable = false)
    private BigDecimal venda;

    /** Quantidade em estoque. */
    @Column(name = "qtdestpro", nullable = false)
    private Integer quantidadeEstoque;

    /** Data de cadastro. */
    @Column(name = "datcadpro")
    private LocalDateTime dataCadastro;

    /** Descrição detalhada. */
    @Column(name = "despro", length = 255)
    private String descricao;

    /** Status de atividade. */
    @Column(name = "atipro", nullable = false)
    private Boolean ativo;

    /** Loja a qual o produto pertence. */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "codloj", nullable = false)
    private Loja loja;

    /** Fornecedor do produto. */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "codfor", nullable = false)
    private Fornecedor fornecedor;

    public Produto() {

    }

    public Produto(Integer id, String nome, String tamanho, String cor, String tipo, BigDecimal custo, BigDecimal venda,
            Integer quantidadeEstoque, LocalDateTime dataCadastro, String descricao, Boolean ativo, Loja loja,
            Fornecedor fornecedor) {
        super();
        this.id = id;
        this.nome = nome;
        this.tamanho = tamanho;
        this.cor = cor;
        this.tipo = tipo;
        this.custo = custo;
        this.venda = venda;
        this.quantidadeEstoque = quantidadeEstoque;
        this.dataCadastro = dataCadastro;
        this.descricao = descricao;
        this.ativo = ativo;
        this.loja = loja;
        this.fornecedor = fornecedor;
    }

    // Getters / Setters

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

    public String getTamanho() {
        return tamanho;
    }

    public void setTamanho(String tamanho) {
        this.tamanho = tamanho;
    }

    public String getCor() {
        return cor;
    }

    public void setCor(String cor) {
        this.cor = cor;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public BigDecimal getCusto() {
        return custo;
    }

    public void setCusto(BigDecimal custo) {
        this.custo = custo;
    }

    public BigDecimal getVenda() {
        return venda;
    }

    public void setVenda(BigDecimal venda) {
        this.venda = venda;
    }

    public Integer getQuantidadeEstoque() {
        return quantidadeEstoque;
    }

    public void setQuantidadeEstoque(Integer quantidadeEstoque) {
        this.quantidadeEstoque = quantidadeEstoque;
    }

    public LocalDateTime getDataCadastro() {
        return dataCadastro;
    }

    public void setDataCadastro(LocalDateTime dataCadastro) {
        this.dataCadastro = dataCadastro;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public Boolean getAtivo() {
        return ativo;
    }

    public void setAtivo(Boolean ativo) {
        this.ativo = ativo;
    }

    public Loja getLoja() {
        return loja;
    }

    public void setLoja(Loja loja) {
        this.loja = loja;
    }

    public Fornecedor getFornecedor() {
        return fornecedor;
    }

    public void setFornecedor(Fornecedor fornecedor) {
        this.fornecedor = fornecedor;
    }
}