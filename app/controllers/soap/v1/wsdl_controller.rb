module Soap
module V1
class WsdlController < ApplicationController
  include ApplicationHelper

  skip_before_filter :verify_authenticity_token

  def create
    expires_now()
    response = '''<?xml version="1.0" encoding="UTF-8"?>
<definitions xmlns="http://schemas.xmlsoap.org/wsdl/" xmlns:tns="urn:SnakesAndLadders:v1" xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:soap-enc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/" name="soap_v1" targetNamespace="urn:SnakesAndLadders:v1">
  <types>
    <schema targetNamespace="urn:SnakesAndLadders:v1" xmlns="http://www.w3.org/2001/XMLSchema">
      <xsd:complexType name="newBoard">
        <xsd:sequence>
          <xsd:element name="id" type="xsd:int"/>
          <xsd:element name="turn" type="xsd:int"/>
          <xsd:element name="layout" type="xsd:string"/>
        </xsd:sequence>
      </xsd:complexType>
      <xsd:complexType name="board">
        <xsd:sequence>
          <xsd:element name="id" type="xsd:int"/>
          <xsd:element name="turn" type="xsd:int"/>
          <xsd:element name="layout" type="xsd:string"/>
        </xsd:sequence>
      </xsd:complexType>
      <xsd:complexType name="boardPlayer">
        <xsd:sequence>
          <xsd:element name="id" type="xsd:int"/>
          <xsd:element name="name" type="xsd:string"/>
          <xsd:element name="position" type="xsd:int"/>
        </xsd:sequence>
      </xsd:complexType>
      <xsd:complexType name="boards">
        <xsd:sequence>
          <xsd:element name="id" type="xsd:int"/>
          <xsd:element name="turn" type="xsd:int"/>
          <xsd:element name="layout" type="xsd:string"/>
        </xsd:sequence>
      </xsd:complexType>
      <xsd:complexType name="resetBoard">
        <xsd:sequence>
          <xsd:element name="id" type="xsd:int"/>
          <xsd:element name="turn" type="xsd:int"/>
          <xsd:element name="layout" type="xsd:string"/>
        </xsd:sequence>
      </xsd:complexType>
      <xsd:complexType name="joinedPlayer">
        <xsd:sequence>
          <xsd:element name="id" type="xsd:int"/>
          <xsd:element name="name" type="xsd:string"/>
          <xsd:element name="position" type="xsd:int"/>
          <xsd:element name="board_id" type="xsd:int"/>
        </xsd:sequence>
      </xsd:complexType>
      <xsd:complexType name="player">
        <xsd:sequence>
          <xsd:element name="id" type="xsd:int"/>
          <xsd:element name="name" type="xsd:string"/>
          <xsd:element name="position" type="xsd:int"/>
          <xsd:element name="board_id" type="xsd:int"/>
        </xsd:sequence>
      </xsd:complexType>
      <xsd:complexType name="updatedPlayer">
        <xsd:sequence>
          <xsd:element name="id" type="xsd:int"/>
          <xsd:element name="name" type="xsd:string"/>
          <xsd:element name="position" type="xsd:int"/>
          <xsd:element name="board_id" type="xsd:int"/>
        </xsd:sequence>
      </xsd:complexType>
      <xsd:complexType name="movedPlayer">
        <xsd:sequence>
          <xsd:element name="id" type="xsd:int"/>
          <xsd:element name="name" type="xsd:string"/>
          <xsd:element name="position" type="xsd:int"/>
        </xsd:sequence>
      </xsd:complexType>
    </schema>
  </types>
  <portType name="soap_v1_port">
    <operation name="createBoard">
      <input message="tns:createBoard"/>
      <output message="tns:createBoard_response"/>
    </operation>
    <operation name="getBoard">
      <input message="tns:getBoard"/>
      <output message="tns:getBoard_response"/>
    </operation>
    <operation name="listBoards">
      <input message="tns:listBoards"/>
      <output message="tns:listBoards_response"/>
    </operation>
    <operation name="resetBoard">
      <input message="tns:resetBoard"/>
      <output message="tns:resetBoard_response"/>
    </operation>
    <operation name="destroyBoard">
      <input message="tns:destroyBoard"/>
      <output message="tns:destroyBoard_response"/>
    </operation>
    <operation name="joinPlayer">
      <input message="tns:joinPlayer"/>
      <output message="tns:joinPlayer_response"/>
    </operation>
    <operation name="getPlayer">
      <input message="tns:getPlayer"/>
      <output message="tns:getPlayer_response"/>
    </operation>
    <operation name="updatePlayer">
      <input message="tns:updatePlayer"/>
      <output message="tns:updatePlayer_response"/>
    </operation>
    <operation name="quitPlayer">
      <input message="tns:quitPlayer"/>
      <output message="tns:quitPlayer_response"/>
    </operation>
    <operation name="playTurn">
      <input message="tns:playTurn"/>
      <output message="tns:playTurn_response"/>
    </operation>
  </portType>
  <binding name="soap_v1_binding" type="tns:soap_v1_port">
    <soap:binding style="rpc" transport="http://schemas.xmlsoap.org/soap/http"/>
    <operation name="createBoard">
      <soap:operation soapAction="createBoard"/>
      <input>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </input>
      <output>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </output>
    </operation>
    <operation name="getBoard">
      <soap:operation soapAction="getBoard"/>
      <input>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </input>
      <output>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </output>
    </operation>
    <operation name="listBoards">
      <soap:operation soapAction="listBoards"/>
      <input>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </input>
      <output>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </output>
    </operation>
    <operation name="resetBoard">
      <soap:operation soapAction="resetBoard"/>
      <input>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </input>
      <output>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </output>
    </operation>
    <operation name="destroyBoard">
      <soap:operation soapAction="destroyBoard"/>
      <input>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </input>
      <output>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </output>
    </operation>
    <operation name="joinPlayer">
      <soap:operation soapAction="joinPlayer"/>
      <input>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </input>
      <output>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </output>
    </operation>
    <operation name="getPlayer">
      <soap:operation soapAction="getPlayer"/>
      <input>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </input>
      <output>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </output>
    </operation>
    <operation name="updatePlayer">
      <soap:operation soapAction="updatePlayer"/>
      <input>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </input>
      <output>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </output>
    </operation>
    <operation name="quitPlayer">
      <soap:operation soapAction="quitPlayer"/>
      <input>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </input>
      <output>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </output>
    </operation>
    <operation name="playTurn">
      <soap:operation soapAction="playTurn"/>
      <input>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </input>
      <output>
        <soap:body use="encoded" encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" namespace="urn:SnakesAndLadders:v1"/>
      </output>
    </operation>
  </binding>
  <service name="service">
    <port name="soap_v1_port" binding="tns:soap_v1_binding">
      <soap:address location="http://localhost:9292/soap/v1/action"/>
    </port>
  </service>
  <message name="createBoard">
  </message>
  <message name="createBoard_response">
    <part name="newBoard" type="tns:newBoard"/>
  </message>
  <message name="getBoard">
    <part name="id" type="xsd:int"/>
  </message>
  <message name="getBoard_response">
    <part name="board" type="tns:board"/>
    <part name="boardPlayer" type="tns:boardPlayer" xsi:minOccurs="0" xsi:maxOccurs="unbounded"/>
  </message>
  <message name="listBoards">
  </message>
  <message name="listBoards_response">
    <part name="boards" type="tns:boards" xsi:minOccurs="0" xsi:maxOccurs="unbounded"/>
  </message>
  <message name="resetBoard">
    <part name="id" type="xsd:int"/>
  </message>
  <message name="resetBoard_response">
    <part name="resetBoard" type="tns:resetBoard"/>
  </message>
  <message name="destroyBoard">
    <part name="id" type="xsd:int"/>
  </message>
  <message name="destroyBoard_response">
    <part name="success" type="xsd:string"/>
  </message>
  <message name="joinPlayer">
    <part name="board_id" type="xsd:int"/>
    <part name="player_name" type="xsd:string"/>
  </message>
  <message name="joinPlayer_response">
    <part name="joinedPlayer" type="tns:joinedPlayer"/>
  </message>
  <message name="getPlayer">
    <part name="id" type="xsd:int"/>
  </message>
  <message name="getPlayer_response">
    <part name="player" type="tns:player"/>
  </message>
  <message name="updatePlayer">
    <part name="id" type="xsd:int"/>
    <part name="name" type="xsd:string"/>
  </message>
  <message name="updatePlayer_response">
    <part name="updatedPlayer" type="tns:updatedPlayer"/>
  </message>
  <message name="quitPlayer">
    <part name="id" type="xsd:int"/>
  </message>
  <message name="quitPlayer_response">
    <part name="success" type="xsd:string"/>
  </message>
  <message name="playTurn">
    <part name="board_id" type="xsd:int"/>
    <part name="player_id" type="xsd:int"/>
  </message>
  <message name="playTurn_response">
    <part name="board_id" type="xsd:int"/>
    <part name="boardLayout" type="xsd:string"/>
    <part name="roll" type="xsd:int"/>
    <part name="movedPlayer" type="tns:movedPlayer"/>
  </message>
</definitions>
    '''
    render :xml => response
  end

end
end
end