﻿using RUnimake.Business.DFe.Servicos.Enums;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using Unimake.Business.DFe.Servicos.NFSe;
using Xunit;

namespace Unimake.DFe.Test.NFSe
{
    /// <summary>
    /// Testar o serviço: ConsultarNfsePDF
    /// </summary>
    public class ConsultarNfsePDFTest
    {
        /// <summary>
        /// Monta o parâmetros, de forma dinâmica, para o cenário de testes
        /// </summary>
        public static IEnumerable<object[]> Parametros => TestUtility.PreparaDadosCenario("ConsultarNfsePDF");

        /// <summary>
        /// Consultar Nfse PDF para saber se a conexão com o webservice está ocorrendo corretamente.
        /// </summary>
        /// <param name="tipoAmbiente">Ambiente para onde deve ser enviado o XML</param>
        [Theory]
        [Trait("DFe", "NFSe")]
        [MemberData(nameof(Parametros))]
        public void ConsultarNfsePDF(TipoAmbiente tipoAmbiente, PadraoNFSe padraoNFSe, string versaoSchema, int codMunicipio)
        {
            var nomeXMLEnvio = "ConsultarNotaPdfEnvio-ped-nfsepdf.xml";

            string arqXML;

            switch (padraoNFSe)
            {
                case PadraoNFSe.NOBESISTEMAS:
                    arqXML = "..\\..\\..\\NFSe\\Resources\\" + padraoNFSe.ToString() + "\\" + versaoSchema + "\\" + tipoAmbiente.ToString() + "\\" + nomeXMLEnvio;
                    break;

                default:
                    arqXML = "..\\..\\..\\NFSe\\Resources\\" + padraoNFSe.ToString() + "\\" + versaoSchema + "\\" + nomeXMLEnvio;
                    break;
            }

            Assert.True(File.Exists(arqXML), "Arquivo " + arqXML + " não foi localizado.");

            var conteudoXML = new XmlDocument();
            conteudoXML.Load(arqXML);

            var configuracao = new Configuracao
            {
                TipoDFe = TipoDFe.NFSe,
                CertificadoDigital = PropConfig.CertificadoDigital,
                TipoAmbiente = tipoAmbiente,
                CodigoMunicipio = codMunicipio,
                Servico = Servico.NFSeConsultarNfsePDF,
                SchemaVersao = versaoSchema,
                MunicipioToken = "99n0556af8e4218e05b88e266fhca55be17b14a4495c269d1db0af57f925f04e77c38f9870842g5g60b6827a9fje8ec9" //Tem município que exige token, então já vamos deixar algo definido para que utilize nos padrões necessários durante o teste unitário. Não é obrigatório para todos os padrões e será utilizado somente nos que solicitam.
            };

            var consultarNfsePDF = new ConsultarNfsePDF(conteudoXML, configuracao);
            consultarNfsePDF.Executar();
        }
    }
}