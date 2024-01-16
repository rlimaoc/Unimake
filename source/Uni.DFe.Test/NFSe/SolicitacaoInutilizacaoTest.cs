﻿using System.Collections.Generic;
using System.IO;
using System.Xml;
using Uni.Business.DFe.Servicos;
using Uni.Business.DFe.Servicos.NFSe;
using Xunit;

namespace Uni.DFe.Test.NFSe
{
    /// <summary>
    /// Testar o serviço: SolicitacaoInutilizacaoNFse
    /// </summary>
    public class SolicitacaoInutilizacaoTest
    {
        /// <summary>
        /// Monta o parâmetros, de forma dinâmica, para o cenário de testes
        /// </summary>
        public static IEnumerable<object[]> Parametros => TestUtility.PreparaDadosCenario("SolicitacaoInutilizacao");

        /// <summary>
        /// Cancelamento Nfe para saber se a conexão com o webservice está ocorrendo corretamente.
        /// </summary>
        /// <param name="tipoAmbiente">Ambiente para onde deve ser enviado o XML</param>
        [Theory]
        [Trait("DFe", "NFSe")]
        [MemberData(nameof(Parametros))]
        public void SolicitacaoInutilizacao(TipoAmbiente tipoAmbiente, PadraoNFSe padraoNFSe, string versaoSchema, int codMunicipio)
        {
            var nomeXMLEnvio = "solicitacaoInutilizacao-ped-inunfse.xml";
            var arqXML = "..\\..\\..\\NFSe\\Resources\\" + padraoNFSe.ToString() + "\\" + versaoSchema + "\\" + nomeXMLEnvio;

            Assert.True(File.Exists(arqXML), "Arquivo " + arqXML + " não foi localizado.");

            var conteudoXML = new XmlDocument();
            conteudoXML.Load(arqXML);

            var configuracao = new Configuracao
            {
                TipoDFe = TipoDFe.NFSe,
                CertificadoDigital = PropConfig.CertificadoDigital,
                TipoAmbiente = tipoAmbiente,
                CodigoMunicipio = codMunicipio,
                Servico = Servico.NFSeSolicitacaoInutilizacao,
                SchemaVersao = versaoSchema,
                MunicipioSenha = "123456",
                MunicipioUsuario = "01001001000113",
                MunicipioToken = "99n0556af8e4218e05b88e266fhca55be17b14a4495c269d1db0af57f925f04e77c38f9870842g5g60b6827a9fje8ec9" //Tem município que exige token, então já vamos deixar algo definido para que utilize nos padrões necessários durante o teste unitário. Não é obrigatório para todos os padrões e será utilizado somente nos que solicitam.
            };

            var solicitaInutilizacao = new SolicitacaoInutilizacao(conteudoXML, configuracao);
            solicitaInutilizacao.Executar();
        }
    }
}