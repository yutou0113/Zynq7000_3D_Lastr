/*
 * i2c_ctr.h
 *
 *  Created on: 2016��10��22��
 *      Author: Administrator
 */

#ifndef I2C_CTR_H_
#define I2C_CTR_H_

void sccb_start(void);
void sccb_end(void);

void sccb_sendbyte( unsigned char value );

void sccb_senddata(unsigned char subaddr,unsigned char value);
#endif /* I2C_CTR_H_ */
