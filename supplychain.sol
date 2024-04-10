//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
contract Tracking{
    enum shipStatus{PENDING,IN_TRANSIT,DELIVERED}
    struct Shipment{
        address sender;
        address receiver;
        uint pickupTime;
        uint deliveryTime;
        //uint orderId;

        shipStatus status;
        uint price;
        bool isPaid;

    
    }
    mapping(address=>Shipment[]) public  shipments;
    uint shipmentno;
    constructor(){
    shipmentno=0;

    }

    function createShipment(address _receiver, uint _pickuptime,uint deliveryTime,uint _price)public payable{
        require(msg.value==_price,"no sufficient ");
        Shipment memory shipment=Shipment(msg.sender,_receiver,_pickuptime,deliveryTime,shipStatus.PENDING,_price,false);
        shipments[msg.sender].push(shipment);
        shipmentno++;

    }
    function startshipment(address _sender,address _receiver,uint256 index)public{
        Shipment storage shipment=shipments[_sender][index];
        require(shipment.receiver==_receiver,"wrong receiver address");
        require(shipment.status==shipStatus.PENDING,"already in transit");
        shipment.status=shipStatus.IN_TRANSIT;
    }
    function completshipment(address _sender,address _receiver,uint256 index)public{
        Shipment storage shipment=shipments[_sender][index];
        require(shipment.receiver==_receiver,"wrong receiver address");
        require(shipment.status==shipStatus.PENDING,"already in transit");
        shipment.status=shipStatus.DELIVERED;
        payable(msg.sender).transfer(shipment.price);
        shipment.isPaid=true;
        shipment.deliveryTime=block.timestamp;


    }

}