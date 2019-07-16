/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package thanosviagens;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;


/**
 *
 * @author Welerson Melo
 */
public class ConnectionDB {
    
    //Method to connect with database given the parameters
    private Connection setConnection(){
        
        String host = "10.27.159.214";
        String port = "5432";
        String database = "bd_trabalho";
        String user = "aluno";
        String password = "aluno";
        
        String url = "jdbc:postgresql://" +  host + ":" + port + "/" + database + "?currentSchema=thanos";

        try{
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(url, user, password);
        } catch(SQLException e){
            String erroMessage = "Erro ao tentar conectar com o banco de dados: " + database + " host: " + host+":"+port;
            System.err.println(erroMessage);
            JOptionPane.showMessageDialog(null, erroMessage + ". As funcionalidades podem não estar funcionando!");
            e.printStackTrace();
        } catch (ClassNotFoundException ex) {   
            Logger.getLogger(ConnectionDB.class.getName()).log(Level.SEVERE, null, ex);
            System.err.println("Erro no drive");
        }
        return null;
    }
    private Connection setConnection(String host, String port, String database, String user, String password){
            String url = "jdbc:postgresql://" +  host + ":" + port + "/" + database + "?currentSchema=" + database;

            try{
                Class.forName("org.postgresql.Driver");
                return DriverManager.getConnection(url, user, password);
            } catch(SQLException e){
                String erroMessage = "Erro ao tentar conectar com o banco de dados: " + database + " host: " + host+":"+port;
                System.err.println(erroMessage);
                JOptionPane.showMessageDialog(null, erroMessage + ". As funcionalidades podem não estar funcionando!");
                e.printStackTrace();
            } catch (ClassNotFoundException ex) {   
                Logger.getLogger(ConnectionDB.class.getName()).log(Level.SEVERE, null, ex);
                System.err.println("Erro no drive");
            }
            return null;
    }
    
    public ResultSet buscaHoteisMediaServico() throws SQLException {
        ConnectionDB connectionBD = new ConnectionDB();
        Connection con = connectionBD.setConnection();
        
        //Consulta banco de dados 
        Statement st = con.createStatement();
        String sql = "SELECT nome, avg(servicos) AS Media_servicos FROM franquia f JOIN avaliacao_usuario a ON(a.franquia_id = f.id_franquia) GROUP BY nome HAVING avg(servicos) > 6 ORDER BY Media_servicos DESC ";
        
        ResultSet result = st.executeQuery(sql);
        
        return result;
    }
    
    public ArrayList<String> buscaTodosHoteis(boolean estacionamento, boolean restaurante, boolean piscina) throws SQLException{
        ArrayList<String> auxList = new ArrayList<>();
        
        ConnectionDB connectionBD = new ConnectionDB();
        Connection con = connectionBD.setConnection();
        
        //Consulta banco de dados 
        Statement st = con.createStatement();
        String sql = "SELECT nome FROM franquia WHERE true";
        
        if(estacionamento){
            sql += " AND estacionamento = true";
        }
        if(restaurante){
            sql += " AND restaurante = true";
        }
        if(piscina){
            sql += " AND piscina = true";
        }
            
        ResultSet result = st.executeQuery(sql);
        
        while(result.next()){
           auxList.add(result.getString(1));
        }
        
        st.close();
        con.close();
        
        return auxList;
    }
    
    public ArrayList<String> buscaPorCidade(String cidade) throws SQLException{
        ArrayList<String> auxList = new ArrayList<>();
        
        ConnectionDB connectionBD = new ConnectionDB();
        Connection con = connectionBD.setConnection();
        
        //Consulta banco de dados 
        Statement st = con.createStatement();
        String sql = "SELECT f.nome FROM endereco JOIN franquia f USING(id_endereco) WHERE cidade LIKE LOWER('"+ cidade +"')";
        ResultSet result = st.executeQuery(sql);
        
        while(result.next()){
           auxList.add(result.getString(1));
        }
        
        st.close();
        con.close();
        
        return auxList;
    }
    
    public ResultSet buscaCidadesHotel(String hotel) throws SQLException{    
        ConnectionDB connectionBD = new ConnectionDB();
        Connection con = connectionBD.setConnection();
        
        //Consulta banco de dados 
        Statement st = con.createStatement();
        String sql = "SELECT f.nome, e.cidade FROM hospedaria h JOIN franquia f USING(cnpj) JOIN endereco e USING(id_endereco) WHERE LOWER(h.nome_comercial) = LOWER('"+ hotel +"')";
        
        ResultSet result = st.executeQuery(sql);
        
        return result;
    }
            
    public ResultSet buscaHotelPorFranquia() throws SQLException {
        ConnectionDB connectionBD = new ConnectionDB();
        Connection con = connectionBD.setConnection();
        
        //Consulta banco de dados 
        Statement st = con.createStatement();
        String sql = "SELECT nome_comercial, count(id_franquia) FROM hospedaria JOIN franquia f USING(cnpj) GROUP BY cnpj ORDER BY nome_comercial";
        ResultSet result = st.executeQuery(sql);
        
        return result;
    }
    
    public ResultSet buscaMediaPorFranquia() throws SQLException {
        ConnectionDB connectionBD = new ConnectionDB();
        Connection con = connectionBD.setConnection();
        
        //Consulta banco de dados 
        Statement st = con.createStatement();
        String sql = "SELECT nome, ((Media_servicos + Media_acomodacoes)/2) AS Media_geral FROM(SELECT nome, avg(servicos) AS Media_servicos, avg(acomodacoes) AS Media_acomodacoes FROM franquia f  JOIN avaliacao_usuario a ON(a.franquia_id = f.id_franquia) GROUP BY nome ) AS medias ORDER BY media_geral DESC ";
        ResultSet result = st.executeQuery(sql);
        
        return result;
    }
    
    public ResultSet buscaUsuariosServa() throws SQLException {
        ConnectionDB connectionBD = new ConnectionDB();
        Connection con = connectionBD.setConnection();
        
        //Consulta banco de dados 
        Statement st = con.createStatement();
        String sql = "SELECT nome_completo, id_reserva_quarto FROM usuario NATURAL JOIN reserva_quarto ORDER BY nome_completo";
        ResultSet result = st.executeQuery(sql);
        
        return result;
    }
    
    public ResultSet buscaUsuariosHospedadosNoMomento() throws SQLException {
        ConnectionDB connectionBD = new ConnectionDB();
        Connection con = connectionBD.setConnection();
        
        //Consulta banco de dados 
        Statement st = con.createStatement();
        
        String diaAtual = new SimpleDateFormat("yyyy-MM-dd").format(Calendar.getInstance().getTime());
        
        System.out.println(diaAtual);
        
        String sql = "SELECT u.nome_completo, rq.saida FROM usuario u JOIN reserva_quarto rq USING (cpf) WHERE rq.entrada <= '"+diaAtual+"' AND rq.saida >= '"+diaAtual+"' ORDER BY u.nome_completo";
        ResultSet result = st.executeQuery(sql);
        
        return result;
    }
    
    public ResultSet buscaUsuarioEspecial() throws SQLException {
        ConnectionDB connectionBD = new ConnectionDB();
        Connection con = connectionBD.setConnection();
        
        //Consulta banco de dados 
        Statement st = con.createStatement();
        
        String sql = "SELECT nome_completo FROM usuario  JOIN reserva_quarto USING (cpf)  WHERE id_tipo_de_quarto IN (SELECT idquarto FROM cama_esta WHERE quant >= 2)";
        ResultSet result = st.executeQuery(sql);
        
        return result;
    }
    
    public ResultSet buscaComentarios() throws SQLException {
        ConnectionDB connectionBD = new ConnectionDB();
        Connection con = connectionBD.setConnection();
        
        //Consulta banco de dados 
        Statement st = con.createStatement();
        
        String sql = "SELECT u.nome_completo, a.comentario, franquia.nome  FROM usuario u JOIN avaliacao_usuario a ON (u.cpf = a.cpf_usuario) NATURAL JOIN (SELECT nome, comentario FROM avaliacao_usuario a JOIN franquia f ON (f.id_franquia = a.franquia_id)) AS franquia ";
        ResultSet result = st.executeQuery(sql);
        
        return result;
    }
    
    
}
